class MatchBannedChampion
  include Mongoid::Document

  # Fields
  field :champion_id, type: Integer
  field :pick_turn, type: Integer

  # Relations
  embedded_in :match_team

  # Indexes

  # Validations

  # Callbacks

  # Functions

end