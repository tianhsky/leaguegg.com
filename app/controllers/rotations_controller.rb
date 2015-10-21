class RotationsController < BaseController

  def show
    if is_crawler?
      @rotation = ChampionService::Service.find_free_champions
    else
      render 'angular/wrapper'
    end
  end

end
