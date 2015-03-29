class Game
  include Mongoid::Document
  include Regionable
  include Platformable

  # Fields
  field :region, type: String
  field :platform_id, type: String
  field :match_id, type: Integer
  field :map_id, type: Integer
  field :match_mode, type: String
  field :match_type, type: String
  field :game_queue_config_id, type: Integer
  field :observer_encryption_key, type: String
  field :started_at, type: Integer
  field :game_length, type: Integer

  # Relations
  embeds_many :match_teams

  # Indexes

  # Validations

  # Callbacks

  # Functions
  def started_at_in_utc
    Time.at(started_at/1000).utc
  end

  def summoner_ids
    match_teams.map{|t|t.match_participants.map{|p|p.summoner_id}}.flatten
  end

  def self.cache_key_summoner_game(summoner_id, region)
    "summoner_game?region=#{region.upcase}&summoner=#{summoner_id}"
  end

  def self.cache_key_game(game_id, region)
    "game?region=#{region.upcase}&game_id=#{game_id}"
  end

end