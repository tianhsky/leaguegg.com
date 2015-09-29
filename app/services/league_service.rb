module LeagueService

  module Riot

    def self.find_league_by_summoner_id(summoner_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.5/league/by-summoner/#{summoner_id}"
      resp = HttpService.get(url, region)
    end

  end

  module Factory

    def self.build_league_hash(json, region)
      region = region.upcase
      json_underscoreized = Utils::JsonParser.underscoreize(json)
      json_underscoreized
    end

  end

  module Service

    def self.find_league_by_summoner_id(summoner_id, region)
      json = Riot.find_league_by_summoner_id(summoner_id, region)
      json = json.first[1][0]
      hash = Factory.build_league_hash(json, region)

      league = League.where({
        region: hash['region'].try(:upcase),
        tier: hash['tier'].try(:upcase),
        queue: hash['queue'].try(:upcase),
        name: hash['name'].try(:upcase)
      }).first

      if league
        league.update_attributes(hash)
      else
        league = League.create(hash)
      end

      league
    end

  end

end