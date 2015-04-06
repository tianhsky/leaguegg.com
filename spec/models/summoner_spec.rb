require 'rails_helper'

RSpec.describe Summoner, :type => :model do

  it 'has a valid factory' do
    profile_json = Utils::JsonLoader.read_from_file("spec/fixtures/summoner_by_id.json").values.first
    profile_hash = Summoner::Factory.build_summoner_hash(profile_json, 'NA')
    summoner = Summoner.new(profile_hash)
    expect(summoner).to be_valid
  end

 
end