# summoner stat by season
class SummonerStat
  include Mongoid::Document
  include TimeTrackable

  # Fields
  field :season, type: String
  field :region, type: String
  field :summoner_id, type: Integer

  # Relations
  embeds_many :player_roles, class_name: 'SummonerStats::PlayerRole'
  embeds_many :player_stats, class_name: 'SummonerStats::PlayerStat'
  embeds_many :ranked_stats_by_champion, class_name: 'SummonerStats::RankedStatByChampion'
  embeds_one :ranked_stat_summary, class_name: 'SummonerStats::RankedStatSummary'

  # Indexes
  index({ summoner_id: 1, region: 1, season: 1 }, { unique: true, :drop_dups => true })

  # Validations
  validates :season, presence: true
  validates :region, presence: true
  validates :summoner_id, presence: true
  validates_uniqueness_of :summoner_id, scope: [:region, :season]

  # Callbacks
  before_validation :sanitize_attrs

  # Functions
  scope :for_summoner, ->(summoner_id, season=nil) do
    r = where({summoner_id: summoner_id})
    r = r.where({ season: season.upcase }) if season
    r
  end

  def summoner
    Summoner.where({summoner_id: summoner_id, region: region}).first
  end

  def sync_from_riot!
    # player_stats_json = Riot.find_summoner_player_stats(summoner_id, region, season)
    player_stats_json = nil
    ranked_stats_json = SummonerStatService::Riot.find_summoner_ranked_stats(summoner_id, region, season)
    season_stats_hash = SummonerStatService::Factory.build_season_stat_hash(ranked_stats_json, player_stats_json, summoner_id, season, region)
    self.update_attributes(season_stats_hash)
  end

  def aggregate_player_roles
    grouped_roles = player_roles.group_by{|r| r['player_role']}
    result = []
    grouped_roles.each do |k, v|
      result << {
        player_role: k,
        games: v.sum{|x|x['games']}
      }
    end
    result
  end

  def outdated?
    return true if self.new_record? || self.updated_at.blank?
    if time = Utils::Time.epunix_to_time(self.updated_at)
      return true if time < Time.now - AppConsts::CHAMPION_SEASON_STATS_EXPIRES_THRESHOLD
    end
    false
  end

  def sanitize_attrs
    self.region.try(:upcase!)
    self.season.try(:upcase!)
  end

end