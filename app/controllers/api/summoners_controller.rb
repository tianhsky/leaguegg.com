module Api
  class SummonersController < Api::BaseController

    def show
      find_summoner
    end

    # def recent_matches
    #   begin
    #     find_summoner
    #   rescue Exception => ex
    #     if reload?
    #       should_reload = reload?
    #     else
    #       should_reload = true if @summoner.recent_matches_update_expired?
    #     end
    #     @recent_matches = @summoner.recent_matches(should_reload)
    #     @recent_stats = Match.aggretate_stats(@recent_matches)

    #   rescue Exception => ex
    #     @error = ex
    #   end
    # end

    protected

    def find_summoner
      if summoner_id.present?
        @summoner = SummonerService::Service.find_summoner_by_summoner_id(summoner_id, region)
      else summoner_name.present?
        @summoner = SummonerService::Service.find_summoner_by_summoner_name(summoner_name, region)
      end

      if @summoner && reload?
        if @summoner.outdated?
          @summoner.sync_from_riot!
        end
      end
    end

    def summoner_id
      tokens = summoner_id_or_name.split('-')
      if tokens.length == 2
        return tokens[0]
      end
      nil
    end

    def summoner_name
      tokens = summoner_id_or_name.split('-')
      if tokens.length == 1
        return tokens[0]
      else
        if tokens.length == 2
          return tokens[1]
        end
      end
      nil
    end

    def summoner_id_or_name
      params['summoner_id_or_name']
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