module Api
  class GamesController < Api::BaseController

    def show
      find_game
    end

    protected

    def find_game
      # return @game = Game.last # todo remove
      @game = GameService::Service.find_game_by_summoner_name(summoner_name, region)
    end

    def summoner_id
      params['summoner_id']
    end

    def summoner_name
      params['summoner_name']
    end

    def region
      params['region']
    end

  end
end