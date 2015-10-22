module ChampionService

  module Riot

    def self.find_free_champions(region='na')
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.2/champion?freeToPlay=true"
      resp = RiotAPI.get(url, region)
    end

  end

end