module SummonerStats
  class RankedStatByRecentChampion
    include Mongoid::Document
    include TimeTrackable

    # Fields
    field :champion_id, type: Integer
    field :games, type: Integer, default: 0
    field :won, type: Integer, default: 0
    field :lost, type: Integer, default: 0
    field :double_kills, type: Integer, default: 0
    field :triple_kills, type: Integer, default: 0
    field :quadra_kills, type: Integer, default: 0
    field :penta_kills, type: Integer, default: 0
    field :team_jungle_kills, type: Integer, default: 0
    field :enemy_jungle_kills, type: Integer, default: 0
    field :minion_kills, type: Integer, default: 0
    field :kills, type: Integer, default: 0
    field :deaths, type: Integer, default: 0
    field :assists, type: Integer, default: 0
    field :physical_to_champion, type: Integer, default: 0
    field :magic_to_champion, type: Integer, default: 0
    field :true_to_champion, type: Integer, default: 0
    field :heals, type: Integer, default: 0
    field :wards_placed, type: Integer, default: 0
    field :wards_killed, type: Integer, default: 0
    field :sight_wards_bought, type: Integer, default: 0
    field :crowd_control_time, type: Integer, default: 0
    field :per_min_gold_at_10m, type: Float, default: 0
    field :per_min_cs_at_10m, type: Float, default: 0
    field :per_min_cs_diff_at_10m, type: Float, default: 0
    field :per_min_dmg_taken_at_10m, type: Float, default: 0
    field :per_min_dmg_taken_diff_at_10m, type: Float, default: 0
    field :timeline_cs, type: Array, default: []
    field :timeline_csd, type: Array, default: []
    field :timeline_xp, type: Array, default: []
    field :timeline_xpd, type: Array, default: []
    field :timeline_dmgt, type: Array, default: []
    field :timeline_dmgtd, type: Array, default: []
    field :total_kill_rate, type: Float, default: 0

    # Aggregated stats
    field :avg_team_jungle_kills, type: Float
    field :avg_enemy_jungle_kills, type: Float
    field :avg_minion_kills, type: Float
    field :avg_kills, type: Float
    field :avg_deaths, type: Float
    field :avg_assists, type: Float
    field :avg_physical_to_champion, type: Float
    field :avg_magic_to_champion, type: Float
    field :avg_true_to_champion, type: Float
    field :avg_heals, type: Float
    field :avg_wards_placed, type: Float
    field :avg_wards_killed, type: Float
    field :avg_sight_wards_bought, type: Float
    field :avg_crowd_control_time, type: Float
    field :avg_gold_at_10m, type: Float
    field :avg_cs_at_10m, type: Float
    field :avg_cs_diff_at_10m, type: Float
    field :avg_per_min_dmg_taken_at_10m, type: Float
    field :avg_per_min_dmg_taken_diff_at_10m, type: Float
    field :avg_timeline_cs, type: Array, default: []
    field :avg_timeline_csd, type: Array, default: []
    field :avg_timeline_xp, type: Array, default: []
    field :avg_timeline_xpd, type: Array, default: []
    field :avg_timeline_dmgt, type: Array, default: []
    field :avg_timeline_dmgtd, type: Array, default: []
    field :avg_kill_rate, type: Float

    # Rates
    field :aggresive_rate, type: Float
    field :win_rate, type: Float
    field :jungle_rate, type: Float
    field :kda_rate, type: Float
    field :helpful_rate, type: Float

    # Relations
    embedded_in :participant, class_name: 'Games::Participant'

    # Validations
    validates :champion_id, presence: true

    # Callbacks
    before_validation :aggregate_stats

    # Functions
    def aggregate_stats
      if games > 0
        calculate_avgs
        calculate_aggresive_rate
        calculate_win_rate
        calculate_kda_rate
        # calculate_helpful_rate
      end
    end

    def calculate_avgs
      self.avg_team_jungle_kills = (team_jungle_kills.to_f / games).round(3)
      self.avg_enemy_jungle_kills = (enemy_jungle_kills.to_f / games).round(3)
      self.avg_minion_kills = (minion_kills.to_f / games).round(3)
      self.avg_kills = (kills.to_f / games).round(3)
      self.avg_deaths = (deaths.to_f / games).round(3)
      self.avg_assists = (assists.to_f / games).round(3)
      self.avg_physical_to_champion = (physical_to_champion.to_f / games).round(3)
      self.avg_magic_to_champion = (magic_to_champion.to_f / games).round(3)
      self.avg_true_to_champion = (true_to_champion.to_f / games).round(3)
      self.avg_heals = (heals.to_f / games).round(3)
      self.avg_wards_placed = (wards_placed.to_f / games).round(3)
      self.avg_wards_killed = (wards_killed.to_f / games).round(3)
      self.avg_sight_wards_bought = (sight_wards_bought.to_f / games).round(3)
      self.avg_crowd_control_time = (crowd_control_time.to_f / games).round(3)
      self.avg_gold_at_10m = ((per_min_gold_at_10m*10).to_f / games).round(3)
      self.avg_cs_at_10m = ((per_min_cs_at_10m*10).to_f / games).round(3)
      self.avg_cs_diff_at_10m = ((per_min_cs_diff_at_10m*10).to_f / games).round(3)
      self.avg_per_min_dmg_taken_at_10m = (per_min_dmg_taken_at_10m.to_f / games).round(3)
      self.avg_per_min_dmg_taken_diff_at_10m = (per_min_dmg_taken_diff_at_10m.to_f / games).round(3)
      self.avg_kill_rate = (total_kill_rate / games).round(3)

      ['timeline_cs', 'timeline_csd', 'timeline_xp', 'timeline_xpd', 'timeline_dmgt', 'timeline_dmgtd'].each do |obj|
        self[obj].each_with_index do |v, index|
          self["avg_#{obj}"][index] = (v.to_f / games).round(3)
        end
      end
    end

    def calculate_aggresive_rate
      quad_diff = quadra_kills - penta_kills
      trip_diff = triple_kills - quadra_kills
      doub_diff = double_kills - triple_kills

      pent = penta_kills * (5*5)
      quad = quad_diff * (4*4)
      trip = trip_diff * (3*3)
      doub = doub_diff * (2*2)
      sing = (kills - penta_kills*5 - quad_diff*4 - trip_diff*3 - doub_diff*2) * (1*1)

      score = (pent + quad + trip + doub + sing).to_f / kills
      score -= 1 # min is 1
      score = 1 if score >= 1

      self.aggresive_rate = score.round(3)
      self.aggresive_rate = nil if self.aggresive_rate.nan?
    end

    def calculate_helpful_rate
      heals_score = heals * AppConsts::HEALS_FACTOR
      wardsp_score = wards_placed * AppConsts::WARDP_FACTOR
      wardsk_score = wards_killed * AppConsts::WARDK_FACTOR
      ccontrol_score = crowd_control_time * AppConsts::CCONTROL_FACTOR
      score = (heals + wardsp_score + wardsk_score + ccontrol_score).to_f / games
      self.helpful_rate = score.round(3)
    end

    def calculate_kda_rate
      rate = (kills + assists).to_f / (deaths == 0 ? 1 : deaths)
      self.kda_rate = rate.round(3)
    end

    def calculate_win_rate
      rate = won.to_f / games
      self.win_rate = rate.round(3)
    end

  end
end