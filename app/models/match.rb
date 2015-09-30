class Match

  include Mongoid::Document
  include TimeTrackable

  # Fields
  field :riot_created_at, type: Integer

  field :match_id, type: Integer
  field :season, type: String
  field :region, type: String
  field :platform_id, type: String
  field :match_mode, type: String
  field :match_type, type: String
  field :match_duration, type: Integer
  field :queue_type, type: String
  field :map_id, type: Integer
  field :match_version, type: String

  field :teams, type: Array

  # Relations

  # Indexes
  index({ match_id: 1, region: 1 }, { unique: true })
  index({ 'teams.participants.summoner_id' => 1, 'region' => 1, 'riot_created_at' => -1 })

  # Validations
  validates :season, presence: true
  validates :region, presence: true
  validates :match_id, presence: true
  validates_uniqueness_of :match_id, scope: [:region]

  # Callbacks
  before_validation :sanitize_attrs

  def find_match_stats_for_summoner(summoner_id)
    self.teams.each do |team|
      team['participants'].each do |participant|
        if participant['summoner_id'].to_s == summoner_id.to_s
          return participant
        end
      end
    end
  end

  def sanitize_attrs
    self.region.try(:upcase!)
    self.season.try(:upcase!)
  end

  def riot_created_at_time
    Time.at(riot_created_at/1000)
  end

  def duration
    match_duration.divmod(60)
  end

end