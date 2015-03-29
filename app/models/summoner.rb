class Summoner
  include Mongoid::Document
  include Regionable
  include Seasonable

  # Fields
  field :season, type: String
  field :region, type: String
  field :summoner_id, type: Integer
  field :player_stats_modified_at, type: Integer
  field :modified_at, type: Integer
  field :profile_icon_id, type: Integer
  field :summoner_level, type: Integer
  field :name, type: String
  field :name_lowercase, type: String # for searching

  # Relations
  embeds_many :summoner_player_stats
  embeds_many :summoner_ranked_stats

  # Indexes
  index({ summoner_id: 1}, { unique: false })
  index({ name_lowercase: 1 }, { unique: false })

  # Validations
  validates :season, presence: true
  validates :region, presence: true
  validates :name, presence: true
  validates :name_lowercase, presence: true
  validates :summoner_id, presence: true
  validates_uniqueness_of :name_lowercase, scope: [:region, :season]

  # Callbacks
  before_validation :store_name_in_lower_case

  # Functions

  protected
  def store_name_in_lower_case
    name_lowercase = name.try(:downcase)
  end
end