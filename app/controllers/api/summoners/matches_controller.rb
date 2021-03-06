module Api
  module Summoners
    class MatchesController < Api::BaseController

      def index
        find_summoner
        @exclude_timeline = true
        @exclude_runes = true
        @exclude_masteries = true
        @exclude_detail_stats = true

        should_reload = false
        if reload?
          should_reload = true
        else
          should_reload = true if @summoner.recent_matches_update_expired?
        end
        @matches = @summoner.recent_matches(should_reload)
      end

      protected

      def find_summoner
        if summoner_id.present?
          @summoner = SummonerService::Service.find_summoner_by_summoner_id(summoner_id, region)
        else summoner_name.present?
          @summoner = SummonerService::Service.find_summoner_by_summoner_name(summoner_name, region)
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

      def region
        params['region']
      end

      def reload?
        return true
        params[:reload].blank? ? false : true
      end

    end
  end
end