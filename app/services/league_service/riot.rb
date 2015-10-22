module LeagueService

  module Riot

    def self.find_league_by_summoner_id(summoner_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.5/league/by-summoner/#{summoner_id}"
      begin
        resp = RiotAPI.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::LeagueNotFoundError.new
      end
    end

    def self.find_league_entries_by_summoner_id(summoner_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.5/league/by-summoner/#{summoner_id}/entry"
      begin
        resp = RiotAPI.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::LeagueNotFoundError.new
      end
    end

    def self.find_master_league(region, type)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.5/league/master?type=#{type}"
      begin
        resp = RiotAPI.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::LeagueNotFoundError.new
      end
    end

    def self.find_challenger_league(region, type)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.5/league/challenger?type=#{type}"
      begin
        resp = RiotAPI.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::LeagueNotFoundError.new
      end
    end

  end

end