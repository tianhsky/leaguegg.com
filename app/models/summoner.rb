class Summoner
  include Mongoid::Document
  include TimeTrackable
  include SummonerService

  # Fields
  field :riot_updated_at, type: Integer
  field :recent_matches_updated_at, type: Integer

  field :region, type: String
  field :summoner_id, type: Integer
  field :profile_icon_id, type: Integer
  field :summoner_level, type: Integer
  field :name, type: String
  field :name_lowercase, type: String # for searching
  field :inquiries, type: Integer, default: 1
  field :twitch_channel, type: String
  field :highest_tier, type: String

  # Relations
  # has_many :summoner_stats

  # Indexes
  index({ summoner_id: 1, region: 1 }, { unique: true, :drop_dups => true })
  index({ name_lowercase: 1, region: 1 }, { unique: true, :drop_dups => true })

  # Validations
  validates :region, presence: true
  validates :name, presence: true
  validates :name_lowercase, presence: true
  validates :summoner_id, presence: true
  validates_uniqueness_of :name_lowercase, scope: [:region], :case_sensitive => false
  validates_uniqueness_of :summoner_id, scope: [:region]

  # Callbacks
  before_validation :sanitize_attrs

  # Functions

  def inc_inquires(num=1)
    self.inc(inquiries: num)
  end

  def sync_from_riot
    profile_json = Riot.find_summoner_by_summoner_id(summoner_id, region)
    profile_hash = Factory.build_summoner_hash(profile_json, region)
    self.update_attributes(profile_hash)
  end

  def recent_matches(reload)
    r = MatchService::Service.find_recent_matches(summoner_id, region, reload)
    if reload
      touch_recent_matches_updated_at
      save
    end
    r
  end

  def recent_matches_updated_at_time
    Time.at(recent_matches_updated_at/1000) if recent_matches_updated_at
  end

  def recent_matches_update_expired?
    if t = recent_matches_updated_at_time
      now = Time.now
      if now - t > AppConsts::RECENT_MATCH_EXPIRES_THRESHOLD
        return true
      end
    else
      return true
    end
    false
  end

  def touch_recent_matches_updated_at
    now = Utils::Time.time_to_epunix(Time.now)
    self.recent_matches_updated_at = now
  end

  def self.search_by_name(name, region)
    name_key = name.try(:downcase).try(:gsub, /\s+/, "")
    region_key = region.try(:upcase)
    self.where(:name_lowercase => name_key, :region => region_key).first
  end

  def outdated?
    return true if self.new_record?
    if time = Utils::Time.epunix_to_time(self.synced_at)
      return true if time < Time.now - AppConsts::SUMMONER_EXPIRES_THRESHOLD
    end
    false
  end

  protected

  def sanitize_attrs
    self.name_lowercase = self.name.try(:downcase).try(:gsub, /\s+/, "")
    self.highest_tier.try(:upcase!)
    self.region.try(:upcase!)
  end


end