class League
  include Mongoid::Document
  include TimeTrackable

  field :region, type: String

  field :tier, type: String
  field :queue, type: String
  field :name, type: String
  field :entries, type: Array

  # Indexes
  index({ region: 1, tier: 1, queue: 1, name: 1 }, { unique: true })

  # Validations
  validates :region, presence: true
  validates :name, presence: true
  validates :tier, presence: true
  validates :queue, presence: true

  validates_uniqueness_of :name, :scope => [:region, :tier, :queue], :case_sensitive => false

  # Callbacks
  before_validation :sanitize_attrs


  def sanitize_attrs
    self.region.try(:upcase!)
    self.tier.try(:upcase!)
    self.queue.try(:upcase!)
    self.name.try(:upcase!)
  end

end