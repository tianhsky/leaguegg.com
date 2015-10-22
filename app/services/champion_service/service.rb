module ChampionService

  module Service

    def self.find_free_champions(region='na')
      rotation = nil
      unless rotation = Rails.cache.read(cache_key_for_free_rotation)
        begin
          champions_json = Riot.find_free_champions(region)
          rotation = Factory.build_champions_hash(champions_json['champions'])
          Rails.cache.write(cache_key_for_free_rotation, rotation, expires_in: AppConsts::FREE_ROTATION_EXPIRES_THRESHOLD)
        rescue
        end
      end
      rotation
    end

    def self.cache_key_for_free_rotation(region='na')
      "free_rotation?region=#{region.upcase}"
    end

  end

end