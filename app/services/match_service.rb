module MatchService

  module Riot
    def self.find_match(match_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/match/#{match_id}"
      resp = HttpService.get(url, region)
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


  end

end