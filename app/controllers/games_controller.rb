class GamesController < ApplicationController

  # layout 'livegame'

  def show
    begin
      @game = Game::Service.find_game_by_summoner_name(summoner_name, region)
    rescue Errors::SummonerNotFoundError => ex
      @error = ex
    rescue Errors::GameNotFoundError => ex
      @error = ex
    end
  end

  protected

  def region
    params['region']
  end

  def summoner_name
    params['summoner_name']
  end

  def set_nav
    @nav = 'game'
  end

end