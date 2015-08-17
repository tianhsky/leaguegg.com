class Match

  include Mongoid::Document
  include TimeTrackable
  include Seasonable
  include Regionable

  # Fields
  field :riot_created_at, type: Integer

  field :match_id, type: Integer
  field :season, type: String
  field :region, type: String
  field :platform_id, type: String
  field :match_mode, type: String
  field :match_type, type: String
  field :match_duration, type: Integer
  field :queue_type, type: String
  field :map_id, type: Integer
  field :match_version, type: String

  field :participants, type: Array
  field :teams, type: Array

  # Relations

  # Indexes
  index({ match_id: 1, region: 1 }, { unique: true })
  index({ 'participants.summoner_id' => 1, 'region' => 1, 'riot_created_at' => -1 })

  # Validations
  validates :season, presence: true
  validates :region, presence: true
  validates :match_id, presence: true 
  validates_uniqueness_of :match_id, scope: [:region]

end