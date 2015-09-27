module SummonerService

  module Riot

    def self.find_summoner_by_summoner_id(summoner_id, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/#{summoner_id}"
      begin
        resp = HttpService.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError
      end
    end

    def self.find_summoner_by_summoner_name(summoner_name, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/by-name/#{summoner_name}"
      begin
        resp = HttpService.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError
      end
    end

  end

  module Factory

    def self.build_summoner_hash(summoner, region)
      region.upcase!
      {
        'region' => region,
        'summoner_id' => summoner['id'],
        'name' => summoner['name'],
        'profile_icon_id' => summoner['profileIconId'],
        'summoner_level' => summoner['summonerLevel'],
        'riot_updated_at' => summoner['revisionDate']
      }
    end

  end

  module Service

    def self.find_summoner_by_summoner_id(summoner_id, region)
      summoner = Summoner.where({id: summoner_id, region: region.upcase}).first
      unless summoner
        summoner_json = Riot.find_summoner_by_summoner_id(summoner_id, region)
        summoner_hash = Factory.build_summoner_hash(summoner_json, region)
        summoner = Summoner.new(summoner_hash)
        summoner.save
      end
      summoner
    end

    def self.find_summoner_by_summoner_name(summoner_name, region)
      summoner = Summoner.search_by_name(summoner_name, region)
      unless summoner
        summoner_json = Riot.find_summoner_by_summoner_name(summoner_name, region)
        summoner_hash = Factory.build_summoner_hash(summoner_json, region)
        summoner = Summoner.new(summoner_hash)
        summoner.save
      end
      summoner
    end

  end

end