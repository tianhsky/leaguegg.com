module SummonerService

  module Riot

    def self.find_summoner_by_summoner_id(summoner_id, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/#{summoner_id}"
      begin
        resp = RiotAPI.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError.new
      end
    end

    def self.find_summoner_by_summoner_name(summoner_name, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/by-name/#{summoner_name}"
      begin
        resp = RiotAPI.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError.new
      end
    end

  end

end