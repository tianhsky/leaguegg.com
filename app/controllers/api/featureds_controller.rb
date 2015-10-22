module Api
  class FeaturedsController < Api::BaseController

    def show
      @featured = GameService::Service.find_current_featured_games('NA')
    end

    protected

    def region
      params['region']
    end

  end
end