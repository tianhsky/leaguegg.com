require 'rails_helper'

RSpec.describe Match, :type => :model do

  it 'has a valid factory' do
    match_json = Utils::JsonLoader.read_from_file("spec/fixtures/match.json")
    match_hash = MatchService::Factory.build_match_hash(match_json)
    match = Match.new(match_hash)
    expect(match).to be_valid
  end

 
end