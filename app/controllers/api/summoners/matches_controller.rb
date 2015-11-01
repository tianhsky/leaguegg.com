module Api
  module Summoners
    class MatchesController < Api::BaseController

      def index
        @matches = MatchService::Service.find_recent_matches(summoner_id, region, reload?)
        @exclude_timeline = true
        @exclude_runes = true
        @exclude_masteries = true
        @exclude_detail_stats = true
      end

      protected

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