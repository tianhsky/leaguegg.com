require 'rails_helper'

RSpec.describe SummonerMatch, :type => :model do

  it 'has a valid factory' do
    matches_json = Utils::JsonLoader.read_from_file("spec/fixtures/match_history.json")
    match_json = matches_json['matches'][0]
    match_hash = SummonerMatch::Factory.build_match_hash(match_json)
    match_hash = SummonerMatch.new(match_hash)
    match_hash.save
    expect(match_hash).to be_valid
  end

end