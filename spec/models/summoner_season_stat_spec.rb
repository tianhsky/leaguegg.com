require 'rails_helper'

RSpec.describe SummonerSeasonStat, :type => :model do

  it 'has a valid factory' do
    profile_json = Utils::JsonLoader.read_from_file("spec/fixtures/summoner_by_id.json").values.first
    profile_hash = Summoner::Factory.build_summoner_hash(profile_json, 'NA')
    summoner = Summoner.new(profile_hash)
    summoner.save

    rank_json = Utils::JsonLoader.read_from_file("spec/fixtures/rank_stats.json")
    player_json = Utils::JsonLoader.read_from_file("spec/fixtures/player_stats.json")
    season_hash = SummonerSeasonStat::Factory.build_season_stat_hash(rank_json, player_json, summoner.summoner_id, 'SEASON2015', 'NA')
    season_stat = SummonerSeasonStat.new(season_hash)
    season_stat.save

    expect(season_stat).to be_valid
  end

 
end