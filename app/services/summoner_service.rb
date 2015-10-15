module SummonerService

  module Riot

    def self.find_summoner_by_summoner_id(summoner_id, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/#{summoner_id}"
      begin
        resp = RiotAPI.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError.new
      end
    end

    def self.find_summoner_by_summoner_name(summoner_name, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.4/summoner/by-name/#{summoner_name}"
      begin
        resp = RiotAPI.get(url, region).values.first
      rescue Errors::NotFoundError => ex
        raise Errors::SummonerNotFoundError.new
      end
    end

  end

  module Factory

    def self.build_summoner_hash(json, region)
      region.upcase!
      json['region'] = region
      json['summoner_id'] = json['id']
      json['riot_updated_at'] = json['revision_date']
      r = Utils::JsonParser.clone_to([
        'region', 'summoner_id', 'riot_updated_at', 'name',
        'profile_icon_id', 'summoner_level'
      ], json, {})
      r
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


    def self.find_or_new_summoners(summoners_hash, region)
      summoners = []
      summoners_hash.each do |summoner_hash|
        summoner_obj_hash = {
          'region' => region.upcase,
          'summoner_id' => summoner_hash['summoner_id'],
          'name' => summoner_hash['summoner_name'],
          'profile_icon_id' => summoner_hash['profile_icon_id']
        }
        if summoner = Summoner.where({region: region.upcase, summoner_id: summoner_hash['summoner_id']}).first
          if summoner.name != summoner_hash['summoner_name']
            summoner.assign_attributes(summoner_obj_hash)
          end
        else
          summoner = Summoner.new(summoner_obj_hash)
        end

        summoners << summoner
      end
      summoners
    end

    def self.store_summoners_to_db(summoners)
      summoners.each do |summoner|
        Thread.new do
          begin
            summoner.save
          rescue
          end
        end
      end
    end

  end

end