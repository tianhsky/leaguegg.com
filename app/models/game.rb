class Game
  include Mongoid::Document
  include TimeTrackable
  include Regionable
  include Platformable
  include GameService

  # Fields
  field :started_at, type: Integer
  field :game_length, type: Integer

  field :region, type: String
  field :platform_id, type: String
  field :game_id, type: Integer
  field :map_id, type: Integer
  field :game_mode, type: String
  field :game_type, type: String
  field :game_queue_config_id, type: Integer
  field :observer_encryption_key, type: String

  # Relations
  embeds_many :teams, class_name: 'Games::Team'

  # Indexes
  index({ game_id: 1, region: 1 }, { unique: true })

  # Validations
  validates :region, presence: true
  validates :game_id, presence: true
  validates_uniqueness_of :game_id, :scope => [:region]

  # Callbacks

  # Functions
  def started_at_time
    Utils::Time.epunix_to_time(started_at)
  end

  def summoner_ids
    teams.map{|t|t.participants.map{|p|p.summoner_id}}.flatten
  end

end