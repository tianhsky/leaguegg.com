class Match
  include Mongoid::Document
  include Regionable
  include Seasonable
  include Platformable

  # Fields
  field :season, type: String
  field :region, type: String
  field :platform_id, type: String
  field :match_id, type: Integer
  field :match_mode, type: String
  field :match_type, type: String
  field :match_version, type: String
  field :match_created_at, type: Integer
  field :match_duration, type: Integer
  field :queue_type, type: String
  field :map_id, type: String

  # Relations
  embeds_many :match_teams

  # Indexes
  index({ match_id: 1 }, { unique: false })
  index({ 'match_teams.match_participants.summoner_id' => 1, match_created_at: -1 }, { unique: false })

  # Validations
  validates :season, presence: true
  validates :region, presence: true
  validates :match_id, presence: true
  validates_uniqueness_of :match_id, :scope => [:region, :season]

  # Callbacks

  # Functions

end