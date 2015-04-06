module SummonerService

  module Riot

    def self.find_summoner_by_summoner_id(summoner_id, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/#{summoner_id}"
      resp = HttpService.get(url).values.first
    end

    def self.find_summoner_by_summoner_name(summoner_name, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/by-name/#{summoner_name}"
      resp = HttpService.get(url).values.first
    end

  end

  module Factory

    def self.build_summoner_hash(summoner, region)
      summoner = summoner.with_indifferent_access
      region.upcase!
      {
        region: region,
        summoner_id: summoner['id'],
        name: summoner['name'],
        profile_icon_id: summoner['profileIconId'],
        summoner_level: summoner['summonerLevel'],
        modified_at: summoner['revisionDate']
      }.with_indifferent_access
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
      summoner = Summoner.where({name_lowercase: summoner_name.downcase, region: region.upcase}).first
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