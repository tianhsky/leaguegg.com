module Api
  module Summoners
    class StatsController < ApiController

      def show
        return season_stats if season_stats?
        return recent_stats if recent_stats?
      end

      def season_stats
        @season_stats = SummonerStatService::Service.find_summoner_season_stats(summoner_id, region, reload?)
        render 'api/summoners/stats/season_stats'
        # respond_with :json => @season_stats
      end

      def recent_stats
        @recent_stats = MatchService::Service.get_matches_aggregation_for_last_x_matches(region, summoner_id, champion_id, 5, [])
        # respond_with :json  => @recent_stats
        render 'api/summoners/stats/recent_stats'
      end

      protected

      def season_stats?
        params[:season_stats].blank? ? false : true
      end

      def recent_stats?
        params[:recent_stats].blank? ? false : true
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
end