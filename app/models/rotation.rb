class Rotation
  include Mongoid::Document
  include TimeTrackable
  include ChampionService

  # Fields
  field :champions, type: Array
  field :date_begin, type: Date

  # Indexes
  index({ date_begin: 1 }, { unique: true })

  # Validations
  validates :date_begin, presence: true
  validates_uniqueness_of :date_begin

  # Functions
  def self.now

  end

end