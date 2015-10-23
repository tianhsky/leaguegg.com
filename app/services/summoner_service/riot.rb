module SummonerService

  module Riot

    def self.find_summoner_by_summoner_ids(summoner_ids, region)
      summoner_ids_str = summoner_ids.join(',')
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/#{summoner_ids_str}"
      begin
        resp = RiotAPI.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError.new
      end
    end

    def self.find_summoner_by_summoner_names(summoner_names, region)
      summoner_names_str = summoner_names.join(',')
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/by-name/#{summoner_names_str}"
      begin
        resp = RiotAPI.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError.new
      end
    end

  end

end