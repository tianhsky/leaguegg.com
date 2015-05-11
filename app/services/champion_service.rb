module ChampionService

  module Riot

    def self.find_free_champions(region='na')
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.2/champion?freeToPlay=true"
      resp = HttpService.get(url)
    end

  end

  module Service

    def self.find_free_champions(region='na')
      unless rotation = Rails.cache.read(cache_key_for_free_rotation)
        champions_json = Riot.find_free_champions(region)
        rotation = Factory.build_champions_hash(champions_json['champions'])
        Rails.cache.write(cache_key_for_free_rotation, rotation, expires_in: AppConsts::FREE_ROTATION_EXPIRES_THRESHOLD)
      end
      rotation
    end

    def self.cache_key_for_free_rotation(region='na')
      "free_rotation?region=#{region.upcase}"
    end

  end

  module Factory

    def self.build_champions_hash(json)
      champions = json.map do |c|
        champ = Consts::Champion.find_by_id(c['id'])
        c = {
          'id' => c['id'],
          'active' => c['active'],
          'bot_enabled' => c['botEnabled'],
          'free_to_play' => c['freeToPlay'],
          'bot_mm_enabled' => c['botMmEnabled'],
          'ranked_play_enabled' => c['rankedPlayEnabled']
        }
        c.merge!(champ)
      end
    end

  end

end