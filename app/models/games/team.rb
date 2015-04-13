module Games
  class Team
    include Mongoid::Document

    # Fields
    field :team_id, type: Integer
    field :banned_champions, type: Array #{champion_id, pick_turn}

    # Relations
    embedded_in :game, class_name: 'Game'
    embeds_many :participants, class_name: 'Games::Participant'

    # Indexes

    # Validations

    # Callbacks

    # Functions

  end
end