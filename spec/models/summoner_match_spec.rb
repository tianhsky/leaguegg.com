require 'rails_helper'

RSpec.describe SummonerMatch, :type => :model do

  it 'has a valid factory' do
    matches_json = Utils::JsonLoader.read_from_file("spec/fixtures/match_history.json")
    match_json = matches_json['matches'][0]
    match_hash = SummonerMatch::Factory.build_summoner_match_hash(match_json, 0)
    summoner_match = SummonerMatch.new(match_hash)
    summoner_match.save
    expect(summoner_match).to be_valid
  end

end