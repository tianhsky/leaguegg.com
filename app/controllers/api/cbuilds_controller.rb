module Api
  class CbuildsController < Api::BaseController

    def index
      
    end

    protected

    def champion_id
      params['champion_id']
    end

  end
end