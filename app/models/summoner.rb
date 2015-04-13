class Summoner
  include Mongoid::Document
  include TimeTrackable
  include Regionable
  include SummonerService

  # Fields
  field :riot_updated_at, type: Integer

  field :region, type: String
  field :summoner_id, type: Integer
  field :profile_icon_id, type: Integer
  field :summoner_level, type: Integer
  field :name, type: String
  field :name_lowercase, type: String # for searching
  field :inquiries, type: Integer, default: 1

  # Relations
  # has_many :summoner_stats

  # Indexes
  index({ summoner_id: 1, region: 1 }, { unique: true })
  index({ name_lowercase: 1, region: 1 }, { unique: true })

  # Validations
  validates :region, presence: true
  validates :name, presence: true
  validates :name_lowercase, presence: true
  validates :summoner_id, presence: true
  validates_uniqueness_of :name_lowercase, scope: [:region]
  validates_uniqueness_of :summoner_id, scope: [:region]

  # Callbacks
  before_validation :store_name_in_lower_case

  # Functions

  def inc_inquires(num=1)
    self.inc(inquiries: 1)
  end

  def sync_from_riot
    profile_json = Riot.find_summoner_by_summoner_id(summoner_id, region)
    profile_hash = Factory.build_summoner_hash(profile_json, region)
    self.update_attributes(profile_hash)
  end

  protected

  def store_name_in_lower_case
    self.name_lowercase = self.name.try(:downcase)
  end
end