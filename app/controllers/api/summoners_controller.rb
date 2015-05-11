module Api
  class SummonersController < ApiController
    
    def show
      if summoner_id.present?
        @summoner = Summoner::Service.find_summoner_by_summoner_id(summoner_id, region)
      elsif summoner_name.present?
        @summoner = Summoner::Service.find_summoner_by_summoner_name(summoner_name, region)
      end
    end

    protected

    def summoner_id
      params['summoner_id']
    end

    def summoner_name
      params['summoner_name']
    end

    def region
      params['region']
    end
    
  end
end