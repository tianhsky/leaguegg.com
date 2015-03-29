class MatchRune
  include Mongoid::Document

  # Fields
  field :rune_id, type: Integer
  field :rank, type: Integer
  
  # Relations
  embedded_in :match_participant

  # Indexes

  # Validations

  # Callbacks

  # Functions

end