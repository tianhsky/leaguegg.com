module SummonerService

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