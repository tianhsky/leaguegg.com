class RotationsController < ApplicationController

  def show
    @rotation = ChampionService::Service.find_free_champions
  end

  protected

  def set_nav
    @nav = 'rotation'
  end

end
