module LeagueService

  module Riot

    def self.find_league_by_summoner_id(summoner_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.5/league/by-summoner/#{summoner_id}"
      begin
        resp = HttpService.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::LeagueNotFoundError
      end
    end

  end

  module Factory

    def self.build_league_hash(json, region)
      return if json.blank?
      region = region.upcase
      if json.is_a? Array
        r = json.map{|x| build_league_hash(x, region)}
      else
        r = Utils::JsonParser.underscoreize(json)
        r.delete('participant_id')
        r['region'] = region
      end
      r
    end

  end

  module Service

    def self.find_league_by_summoner_id(summoner_id, region)
      json = Riot.find_league_by_summoner_id(summoner_id, region)
      if json.is_a?(Array)
        json = json.find{|x|x['participantId'].to_s == summoner_id.to_s}
      end
      hash = Factory.build_league_hash(json, region)
      league = League.find_or_create_by({
        region: hash['region'].try(:upcase),
        tier: hash['tier'].try(:upcase),
        queue: hash['queue'].try(:upcase),
        name: hash['name'].try(:upcase)
      })
      league.update_attributes(hash)
      league
    end

  end

end