class Summoner
  include Mongoid::Document
  include TimeTrackable

  # Fields
  field :riot_updated_at, type: Integer
  field :recent_matches_updated_at, type: Integer

  field :region, type: String
  field :summoner_id, type: Integer
  field :profile_icon_id, type: Integer
  field :summoner_level, type: Integer
  field :name, type: String
  field :name_lowercase, type: String # for searching
  field :twitch_channel, type: String
  field :highest_tier, type: String
  field :league_entries, type: Array

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

  def self.search_by_name(name, region)
    name_key = name.try(:downcase).try(:gsub, /\s+/, "")
    region_key = region.try(:upcase)
    self.where(:name_lowercase => name_key, :region => region_key).first
  end

  def sync_from_riot!
    # basic info
    profile_json = SummonerService::Riot.find_summoner_by_summoner_ids([summoner_id], region).values.first
    profile_hash = SummonerService::Factory.build_summoner_hash(profile_json, region)
    self.assign_attributes(profile_hash)

    # league entries
    begin
      league_entries = LeagueService::Riot.find_league_entries_by_summoner_ids([summoner_id], region).values.first
      self.league_entries = league_entries
    rescue
    end

    # touch
    self.touch_synced_at

    # persist
    self.save
  end

  def outdated?
    return true if self.new_record? || self.synced_at.blank?
    if time = Utils::Time.epunix_to_time(self.synced_at)
      return true if time < Time.now - AppConsts::SUMMONER_EXPIRES_THRESHOLD
    end
    false
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

  def primary_league
    if self.league_entries
      if league = self.league_entries[0]
        r = {}
        r['tier'] = league['tier']
        r['division'] = league.try(:[], 'entries').try(:first).try(:[],'division')
        r['name'] = league['name']
        return r
      end
    end
    nil
  end

  def region_name
    Consts::Platform.find_by_region(self.region)['name']
  end

  protected

  def sanitize_attrs
    self.name_lowercase = self.name.try(:downcase).try(:gsub, /\s+/, "")
    self.highest_tier.try(:upcase!)
    self.region.try(:upcase!)
  end

end