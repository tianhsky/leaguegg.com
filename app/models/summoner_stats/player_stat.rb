module SummonerStats
  class PlayerStat
    include Mongoid::Document
    include TimeTrackable

    # Fields
    field :riot_updated_at, type: Integer

    field :player_stat_summary_type, type: String
    field :wins, type: Integer
    field :losses, type: Integer
    field :stats, type: Hash

    # Relations
    embedded_in :summoner_stat, class_name: 'SummonerStat'

    # Validations

  end
end