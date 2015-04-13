class SummonerMatch
  include Mongoid::Document
  include TimeTrackable
  include Seasonable
  include Regionable
  include SummonerMatchService

  # Fields
  field :riot_created_at, type: Integer

  field :match_id, type: Integer
  field :summoner_id, type: Integer
  field :summoner_name, type: String
  field :season, type: String
  field :region, type: String
  field :platform_id, type: String
  field :profile_icon, type: Integer
  field :match_mode, type: String
  field :match_type, type: String
  field :match_duration, type: Integer
  field :queue_type, type: String
  field :map_id, type: Integer
  field :match_version, type: String
  field :match_history_uri, type: String

  field :participant_id, type: Integer
  field :team_id, type: Integer
  field :spell1_id, type: Integer
  field :spell2_id, type: Integer
  field :highest_achieved_season_tier, type: String
  field :masteries, type: Array
  field :runes, type: Array
  field :timeline, type: Hash
  field :stats, type: Hash

  # Relations

  # Indexes
  index({ match_id: 1, summoner_id: 1, region: 1 }, { unique: true })

  # Validations
  validates :season, presence: true
  validates :region, presence: true
  validates :match_id, presence: true 
  validates :summoner_id, presence: true
  validates_uniqueness_of :match_id, scope: [:summoner_id, :region]

  # Functions
  scope :for_summoner, ->(summoner_id, season=nil) do
    r = where({summoner_id: summoner_id})
    r = r.where({ season: season.upcase }) if season
    r
  end

  def summoner
    Summoner.where({summoner_id: summoner_id, region: region}).first
  end


end