module Api
  class FeaturedsController < ApiController

    def show
      @featured = Game::Service.find_current_featured_games('NA')
    end

    protected

    def region
      params['region']
    end

  end
end