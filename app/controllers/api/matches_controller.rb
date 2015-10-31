module Api
  class MatchesController < Api::BaseController

    def show
      @match = MatchService::Service.find_match(match_id, region, include_timeline)
    end

    protected

    def region
      params['region']
    end

    def match_id
      params['id']
    end

    def include_timeline
      true
    end

  end
end