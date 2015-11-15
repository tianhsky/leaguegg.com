module Games
  class Participant
    include Mongoid::Document

    # Fields
    field :participant_id, type: Integer
    field :spell1_id, type: Integer
    field :spell2_id, type: Integer
    field :summoner_id, type: Integer
    field :summoner_name, type: String
    field :summoner_level, type: Integer
    field :champion_id, type: Integer
    field :highest_achieved_season_tier, type: String
    field :match_history_uri, type: String
    field :profile_icon_id, type: Integer
    field :bot, type: Boolean
    field :runes, type: Array #{rune_id, rank}
    field :masteries, type: Array #{mastery_id, rank}
    field :meta, type: Hash, default: {}
    field :league_entry, type: Hash, default: {}
    field :player_roles, type: Array, default: []

    # Relations
    embedded_in :team, class_name: 'Games::Team'
    embeds_one :ranked_stat_by_recent_champion, class_name: 'SummonerStats::RankedStatByRecentChampion'
    embeds_one :ranked_stat_by_champion, class_name: 'SummonerStats::RankedStatByChampion'

    # Indexes

    # Validations

    # Callbacks

    # Functions

  end
end