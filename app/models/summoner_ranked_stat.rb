class SummonerRankedStat
  include Mongoid::Document

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

  # Calculated Fields
  field :offensive_rate
  field :defensive_rate
  field :cs_rate
  field :win_rate
  field :avg_kills
  field :avg_deaths
  field :avg_assists

  # Relations
  embedded_in :summoner_season_stat
  embedded_in :match_participant

  # Validations
  validates :champion_id, presence: true

  # Callbacks
  before_validation :aggregate_stats

  # Functions
  protected

  def aggregate_stats
    calculate_offensive_rate
    calculate_defensive_rate
    calculate_cs_rate
    calculate_win_rate
    calculate_avg_kills
    calculate_avg_deaths
    calculate_avg_assists
  end

  def calculate_offensive_rate
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

    self.offensive_rate = score.round(3)
  end

  def calculate_defensive_rate
    rate = total_assists.to_f / (total_assists + total_deaths).to_f
    self.defensive_rate = rate.round(3)
  end

  def calculate_cs_rate
    rate = (total_minion_kills / total_sessions_played).to_f / 300.to_f
    self.cs_rate = rate.round(3)
  end

  def calculate_win_rate
    rate = total_sessions_won.to_f / total_sessions_played.to_f
    self.win_rate = rate.round(3)
  end

  def calculate_avg_kills
    rate = total_champion_kills.to_f / total_sessions_played.to_f
    self.avg_kills = rate.round(3)
  end

  def calculate_avg_deaths
    rate = total_deaths.to_f / total_sessions_played.to_f
    self.avg_deaths = rate.round(3)
  end

  def calculate_avg_assists
    rate = total_assists.to_f / total_sessions_played.to_f
    self.avg_assists = rate.round(3)
  end

end