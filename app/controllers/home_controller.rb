class HomeController < ApplicationController

  def index
    @featured = Game::Service.find_current_featured_games('NA')
  end

  protected

  def set_nav
    @nav = 'game'
  end

end
