class SummonerSeasonStat
  include Mongoid::Document
  include Seasonable
  include Regionable
  include SummonerSeasonStatsService

  # Fields
  field :season, type: String
  field :region, type: String
  field :summoner_id, type: Integer
  field :ranked_stats_modified_at, type: Integer

  # Relations
  # belongs_to :summoner, foreign_key: 'app_summoner_id'
  embeds_many :summoner_player_stats
  embeds_many :summoner_ranked_stats
  embeds_one :summoner_ranked_stat_summary

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

end