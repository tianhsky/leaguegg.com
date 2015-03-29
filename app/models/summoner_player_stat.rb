class SummonerPlayerSummary
  include Mongoid::Document

  # Fields
  field :modified_at, type: Integer
  field :player_stat_summary_type, type: String
  field :wins, type: Integer
  field :aggregated_stats, type: Hash

  # Relations
  embedded_in :summoner

  # Validations

end