module Api
  class MatchesController < Api::BaseController

    def show
      @match = MatchService::Service.find_match(match_id, region, include_timeline)
      # render :json => @match
    end

    protected

    def region
      params['region']
    end

    def match_id
      params['match_id']
    end

    def include_timeline
      true
    end

  end
end