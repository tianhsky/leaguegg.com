module Api
  class GamesController < ApiController

    def show
      find_game
    end

    protected

    def find_game
      if summoner_id.present?
        @game = Game::Service.find_game_by_summoner_id(summoner_id, region)
      elsif summoner_name.present?
        @game = Game::Service.find_game_by_summoner_name(summoner_name, region)
      end
    end

    def summoner_id
      params[:summoner_id]
    end

    def summoner_name
      params[:summoner_name]
    end

    def region
      params[:region]
    end

  end
end