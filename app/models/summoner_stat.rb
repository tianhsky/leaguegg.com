# summoner stat by season
class SummonerStat
  include Mongoid::Document
  include TimeTrackable
  include Seasonable
  include Regionable
  include SummonerStatService

  # Fields
  field :season, type: String
  field :region, type: String
  field :summoner_id, type: Integer

  # Relations
  # belongs_to :summoner, foreign_key: 'app_summoner_id'
  embeds_many :player_stats, class_name: 'SummonerStats::PlayerStat'
  embeds_many :ranked_stats_by_champion, class_name: 'SummonerStats::RankedStatByChampion'
  embeds_one :ranked_stat_summary, class_name: 'SummonerStats::RankedStatSummary'

  # Indexes
  index({ summoner_id: 1, region: 1, season: 1 }, { unique: true })

  # Validations
  validates :season, presence: true
  validates :region, presence: true
  validates :summoner_id, presence: true
  validates_uniqueness_of :summoner_id, scope: [:region, :season]

  # Functions
  scope :for_summoner, ->(summoner_id, season=nil) do
    r = where({summoner_id: summoner_id})
    r = r.where({ season: season.upcase }) if season
    r
  end

  def summoner
    Summoner.where({summoner_id: summoner_id, region: region}).first
  end

  def sync_from_riot
    player_stats_json = Riot.find_summoner_player_stats(summoner_id, region, season)
    ranked_stats_json = Riot.find_summoner_ranked_stats(summoner_id, region, season)
    season_stats_hash = Factory.build_season_stat_hash(ranked_stats_json, player_stats_json, summoner_id, season, region)
    self.update_attributes(season_stats_hash)
  end

  def outdated?
    return true if self.new_record?
    if time = Utils::Time.time_to_epunix(self.synced_at)
      return true if time < Time.now - AppConsts::CHAMPION_SEASON_STATS_EXPIRES_THRESHOLD
    end
    false
  end

end