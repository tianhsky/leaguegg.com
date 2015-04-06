class Game
  include Mongoid::Document
  include Regionable
  include Platformable
  include GameService

  # Fields
  field :region, type: String
  field :platform_id, type: String
  field :match_id, type: Integer
  field :map_id, type: Integer
  field :match_mode, type: String
  field :match_type, type: String
  field :game_queue_config_id, type: Integer
  field :observer_encryption_key, type: String
  field :started_at, type: Integer
  field :game_length, type: Integer

  # Relations
  embeds_many :match_teams

  # Indexes
  index({ match_id: 1, region: 1 }, { unique: true })

  # Validations
  validates :region, presence: true
  validates :match_id, presence: true
  validates_uniqueness_of :match_id, :scope => [:region]

  # Callbacks

  # Functions
  def started_at_time
    Time.at(started_at/1000)
  end

  def summoner_ids
    match_teams.map{|t|t.match_participants.map{|p|p.summoner_id}}.flatten
  end

end