module Api
  class RotationsController < ApiController

    def show
      @rotation = ChampionService::Service.find_free_champions
      render :json => @rotation
    end

    protected

    def region
      params['region']
    end

  end
end