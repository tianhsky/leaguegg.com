# Services related to current game, fetch live game status from riot or cache
module GameService

  module Riot

    def self.find_game_by_summoner_id(summoner_id, region)
      Rails.logger.tagged('GAME'){Rails.logger.info("Find by summoner id")}
      platform_id = Consts::Platform.find_by_region(region)['platform']
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/#{platform_id}/#{summoner_id}"
      begin
        resp = RiotAPI.get(url, region)
      rescue Errors::NotFoundError => ex
        raise Errors::GameNotFoundError.new
      end
    end

    def self.find_current_featured_game(region)
      url = "https://#{region.downcase}.api.pvp.net/observer-mode/rest/featured"
      resp = RiotAPI.get(url, region)
    end

  end

end