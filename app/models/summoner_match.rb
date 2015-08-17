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
  field :champion_id, type: Integer
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
  # index({ summoner_id: 1, region: 1, riot_created_at: -1 })

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

  def self.aggretate_stats(matches)
    r = {
      'kills' => 0,
      'deaths' => 0,
      'assists' => 0,
      'wons' => 0,
      'losts' => 0,
      'games' => 0,
      'win_rate' => 0,
      'kda' => 0
    }
    matches.each do |m|
      r['games'] += 1
      r['kills'] += m.stats['kills']
      r['deaths'] += m.stats['deaths']
      r['assists'] += m.stats['assists']
      if m.stats['winner']
        r['wons'] += 1
      else
        r['losts'] += 1
      end
    end
    ka = r['kills'] + r['assists']
    d = r['deaths']
    if ka!=0 && d!=0
      r['kda'] = (ka.to_f / d).round(2)
    end

    if r['games'] > 0
      r['win_rate'] = (r['wons'].to_f / r['games']).round(2)
    end
    r
  end

  def summoner
    Summoner.where({summoner_id: summoner_id, region: region}).first
  end

  def best_kills
    return 'Penta Kill' if stats['penta_kills'] != 0
    return 'Quadra Kill' if stats['quadra_kills'] != 0
    return 'Triple Kill' if stats['triple_kills'] != 0
    return 'Double Kill' if stats['double_kills'] != 0
    nil
  end

  def kda
    r = nil
    ka = stats['kills'] + stats['assists']
    d = stats['deaths']
    if ka!=0 && d!=0
      r = (ka.to_f / d).round(2)
    end
    r
  end

  def riot_created_at_time
    Time.at(riot_created_at/1000)
  end

  def duration
    match_duration.divmod(60)
  end

end