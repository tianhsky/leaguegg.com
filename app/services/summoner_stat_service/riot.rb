module SummonerStatService

  module Riot

    def self.find_summoner_player_stats(summoner_id, region, season)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.3/stats/by-summoner/#{summoner_id}/summary?season=#{season.upcase}"
      resp = RiotAPI.get(url, region)
    end

    def self.find_summoner_ranked_stats(summoner_id, region, season)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.3/stats/by-summoner/#{summoner_id}/ranked?season=#{season.upcase}"
      begin
        resp = RiotAPI.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::StatsNotFoundError.new
      end
    end

  end

end