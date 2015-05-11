module Consts

  class Champion < Consts::StaticData

    @lock = Mutex.new
    CACHE_KEY = 'static_champions'

    def self.find_by_id(id)
      setup
      @data[id.to_i] || {}
    end

    def self.find_by_name(name)
      setup
      found = @data.find{|id,c|c['name'].downcase == name.downcase}
      found ? found[1] : {}
    end

    def self.setup
      setup_from_api
    end

    def self.setup_from_file
      unless @data
        @lock.synchronize do
          json_file_path = 'app/models/consts/data/champions.json'
          @json ||= Utils::JsonLoader.read_from_file(json_file_path).with_indifferent_access
          @data ||= load_data
        end
      end
    end

    def self.setup_from_api
      if local_cache_expired?
        unless @data = Rails.cache.read(CACHE_KEY)
          @lock.synchronize do
            @json = StaticDataService::Riot.fetch_champions
            @data = load_data
            Rails.cache.write(CACHE_KEY, @data, expires_in: AppConsts::RIOT_CONSTS_EXPIRES_THRESHOLD)
            @updated_at = Time.now
          end
        end
      end
    end

    def self.load_data
      @version = @json['version']
      r = {}
      @json['data'].each do |name, value|
        r["#{value['id']}".to_i] = {
          "id" => value['id'],
          "key" => value['key'],
          "name" => value['name'],
          "title" => value['title'],
          "img" => "https://ddragon.leagueoflegends.com/cdn/#{@version}/img/champion/#{value['key']}.png",
          "img_loadings" => ["https://ddragon.leagueoflegends.com/cdn/img/champion/loading/#{value['key']}_0.jpg"],
          "img_splashes" => ["https://ddragon.leagueoflegends.com/cdn/img/champion/splash/#{value['key']}_0.jpg"]
        }
      end
      r
    end

  end

end