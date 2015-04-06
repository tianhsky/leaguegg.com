class SummonerPlayerStat
  include Mongoid::Document

  # Fields
  field :modified_at, type: Integer
  field :player_stat_summary_type, type: String
  field :wins, type: Integer
  field :losses, type: Integer 
  field :stats, type: Hash

  # Relations
  embedded_in :summoner_season_stat

  # Validations

end