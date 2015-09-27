class HomeController < ApplicationController

  def show
    @featured = Game::Service.find_current_featured_games('NA')
  end

  protected

  def set_nav
    @nav = 'game'
  end

end
