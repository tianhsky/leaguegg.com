module Games
  class Team
    include Mongoid::Document

    # Fields
    field :team_id, type: Integer
    field :banned_champions, type: Array #{champion_id, pick_turn}

    # field :winner, type: Boolean
    # field :first_blood, type: Boolean
    # field :first_tower, type: Boolean
    # field :first_inhibitor, type: Boolean
    # field :first_baron, type: Boolean
    # field :first_dragon, type: Boolean
    # field :tower_kills, type: Integer
    # field :inhibitor_kills, type: Integer
    # field :baron_kills, type: Integer
    # field :dragon_kills, type: Integer
    # field :vilemaw_kills, type: Integer
    # field :dominion_victory_score, type: Integer

    # Relations
    embedded_in :game, class_name: 'Game'
    embeds_many :participants, class_name: 'Games::Participant'

    # Indexes

    # Validations

    # Callbacks

    # Functions

  end
end