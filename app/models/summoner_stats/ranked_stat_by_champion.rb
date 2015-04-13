module SummonerStats
  class RankedStatByChampion
    include Mongoid::Document
    include TimeTrackable

    # Fields
    field :champion_id, type: Integer
    field :total_sessions_played, type: Integer
    field :total_sessions_lost, type: Integer
    field :total_sessions_won, type: Integer
    field :total_champion_kills, type: Integer
    field :total_damage_dealt, type: Integer
    field :total_damage_taken, type: Integer
    field :most_champion_kills, type: Integer
    field :total_minion_kills, type: Integer
    field :total_double_kills, type: Integer
    field :total_triple_kills, type: Integer
    field :total_quadra_kills, type: Integer
    field :total_penta_kills, type: Integer
    field :total_unreal_kills, type: Integer
    field :total_deaths, type: Integer
    field :total_gold_earned, type: Integer
    field :most_spells_cast, type: Integer
    field :total_turrets_killed, type: Integer
    field :total_physical_damage_dealt, type: Integer
    field :total_magic_damage_dealt, type: Integer
    field :total_first_blood, type: Integer
    field :total_assists, type: Integer
    field :max_champions_killed, type: Integer
    field :max_num_deaths, type: Integer

    # Aggregated stats
    field :aggresive_rate, type: Float
    field :win_rate, type: Float
    field :avg_kills, type: Float
    field :avg_deaths, type: Float
    field :avg_assists, type: Float
    field :avg_minion_kills, type: Integer
    field :cs_rate, type: Float

    # Relations
    embedded_in :summoner_stat, class_name: 'SummonerStat'
    embedded_in :participant, class_name: 'Games::Participant'

    # Validations
    validates :champion_id, presence: true

    # Callbacks
    before_validation :aggregate_stats

    # Functions
    def aggregate_stats
      if total_sessions_played > 0
        calculate_avgs
        calculate_aggressive_rate
        calculate_win_rate
        # calculate_cs_rate
      end
    end

    def calculate_aggressive_rate
      quad_diff = total_quadra_kills - total_penta_kills
      trip_diff = total_triple_kills - total_quadra_kills
      doub_diff = total_double_kills - total_triple_kills

      pent = total_penta_kills * (5*5)
      quad = quad_diff * (4*4)
      trip = trip_diff * (3*3)
      doub = doub_diff * (2*2)
      sing = (total_champion_kills - total_penta_kills*5 - quad_diff*4 - trip_diff*3 - doub_diff*2) * (1*1)

      score = (pent + quad + trip + doub + sing).to_f / total_champion_kills.to_f
      score -= 1 # min is 1
      score = 1 if score >= 1

      self.aggresive_rate = score.round(3)
    end

    def calculate_defensive_rate
      rate = total_assists.to_f / (total_assists + total_deaths).to_f
      self.defensive_rate = rate.round(3)
    end

    def calculate_avgs
      self.avg_kills = (total_champion_kills.to_f / total_sessions_played).round(3)
      self.avg_deaths = (total_deaths.to_f / total_sessions_played).round(3)
      self.avg_assists = (total_assists.to_f / total_sessions_played).round(3)
      self.avg_minion_kills = (total_minion_kills.to_f / total_sessions_played).round(3)
    end

    def calculate_cs_rate
      rate = (total_minion_kills / total_sessions_played).to_f / AppConsts::CS_KILLS_CAP
      self.cs_rate = rate.round(3)
    end

    def calculate_win_rate
      rate = total_sessions_won.to_f / total_sessions_played
      self.win_rate = rate.round(3)
    end

  end
end