module Api
  class SummonersController < ApiController

    def show
      find_summoner
    end

    def recent_matches
      begin
        find_summoner
      rescue Exception => ex
        if reload?
          should_reload = reload?
        else
          should_reload = true if @summoner.recent_matches_update_expired?
        end
        @recent_matches = @summoner.recent_matches(should_reload)
        @recent_stats = Match.aggretate_stats(@recent_matches)

      rescue Exception => ex
        @error = ex
      end
    end

    protected

    def find_summoner
      if summoner_name.present?
        @summoner = Summoner::Service.find_summoner_by_summoner_name(summoner_name, region)
      elsif summoner_id.present?
        @summoner = Summoner::Service.find_summoner_by_summoner_id(summoner_id, region)
      end

      # if @summoner && reload?
        if @summoner.outdated?
          @summoner.sync_from_riot!
        end
      # end
    end

    def summoner_id
      params['summoner_id']
    end

    def summoner_name
      params['summoner_name']
    end

    def champion_id
      params['champion_id']
    end

    def champion_name
      params['champion_name']
    end

    def region
      params['region']
    end

    def reload?
      params[:reload].blank? ? false : true
    end

  end
end