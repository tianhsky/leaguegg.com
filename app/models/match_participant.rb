class MatchParticipant
  include Mongoid::Document

  # Fields
  field :participant_id, type: Integer
  field :spell1_id, type: Integer
  field :spell2_id, type: Integer
  field :summoner_id, type: Integer
  field :summoner_name, type: String
  field :champion_id, type: Integer
  field :highest_achieved_season_tier, type: String
  field :match_history_uri, type: String
  field :profile_icon_id, type: Integer
  field :bot, type: Boolean
  field :time_line, type: Hash
  field :stats, type: Hash
  
  # Relations
  embeds_many :match_masteries
  embeds_many :match_runes
  embedded_in :match_team

  # Indexes

  # Validations

  # Callbacks

  # Functions

end