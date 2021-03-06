require 'rails_helper'

RSpec.describe League, :type => :model do

  it 'has a valid factory' do
    league_json = Utils::JsonLoader.read_from_file("spec/fixtures/league.json").values.first
    league_json = league_json[0]
    league_hash = LeagueService::Factory.build_league_hash(league_json, 'NA')
    league = League.new(league_hash)
    expect(league).to be_valid
  end

 
end