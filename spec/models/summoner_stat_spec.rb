require 'rails_helper'

RSpec.describe SummonerStat, :type => :model do

  it 'has a valid factory' do
    rank_json = Utils::JsonLoader.read_from_file("spec/fixtures/rank_stats.json")
    player_json = Utils::JsonLoader.read_from_file("spec/fixtures/player_stats.json")
    summoner_id = rank_json['summoner_id']
    season_hash = SummonerStat::Factory.build_season_stat_hash(rank_json, player_json, summoner_id, 'SEASON2015', 'NA')
    season_stat = SummonerStat.new(season_hash)
    season_stat.save

    expect(season_stat).to be_valid
  end

 
end