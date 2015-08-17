module MatchService

  module Riot
    def self.find_match(match_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/match/#{match_id}"
      resp = HttpService.get(url)
    end
  end

  module Factory

    def self.build_match_hash(json, game_hash)

    end

  end

  module Service

    def self.find_match(match_id, region, game_hash)
      region = region.downcase

      # find in db first
      match = Match.where(match_id: match_id, region: region.upcase).first
      return match if match

      # if not found in db, find through api
      match_json = Riot::find_match(match_id, region)
      matches = []
      
    end

    def self.find_recent_matches(summoner_id, region, reload)
      region = region.downcase
      if reload
        matches = []
        games_json = SummonerMatch::Riot::find_recent_games(summoner_id, region)
        games_hash = SummonerMatch::Factory::build_games_hash(games_json)
        games_hash.each do |g|
          game_id = g['game_id']
          match = Service::find_match(game_id, region, g)
          matches << match if match
        end
      else
        matches = Match.where('participants.summoner_id' => summoner_id, 'region' => region.upcase).order_by(['riot_created_at', -1])
      end
      matches
    end

  end

end