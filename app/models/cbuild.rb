class Cbuild
  include Mongoid::Document
  include TimeTrackable
  include AASM

  # Fields
  field :champion_id, type: Integer
  field :items, type: Hash
  field :skills, type: Array
  field :votes, type: Integer
  field :aasm_state, type: String

  # Indexes
  index({ champion_id: 1 }, { unique: false })

  # Validations
  # validates_uniqueness_of :champion_id

  # Functions
  aasm do
    state :pending, :initial => true
    state :approved

    event :approve do
      transitions :from => :pending, :to => :approved
    end

    event :disapprove do
      transitions :from => :approved, :to => :pending
    end
  end

end