class MatchMastery
  include Mongoid::Document

  # Fields
  field :mastery_id, type: Integer
  field :rank, type: Integer
  
  # Relations
  embedded_in :match_participant

  # Indexes

  # Validations

  # Callbacks

  # Functions

end