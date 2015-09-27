module Consts

  class Mastery < Consts::StaticData

    @lock = Mutex.new
    CACHE_KEY = 'static_masteries'

    def self.find_by_id(id)
      setup
      @data[id.to_i] || {}
    end

    def self.find_by_name(name)
      setup
      found = @data.find{|id,v|v['name'].downcase == name.downcase}
      found ? found[1] : {}
    end

    def self.setup
      begin
        setup_from_api
      rescue
        setup_from_file
      end
    end

    def self.setup_from_file
      unless @data
        @lock.synchronize do
          json_file_path = 'app/models/consts/data/masteries.json'
          @json = Utils::JsonLoader.read_from_file(json_file_path).with_indifferent_access
          @data = load_data
        end
      end
    end

    def self.setup_from_api
      if local_cache_expired?
        unless @data = Rails.cache.read(CACHE_KEY)
          @lock.synchronize do
            @json = StaticDataService::Riot.fetch_masteries
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
          "name" => value['name'],
          "description" => value['description'],
          "img" => "http://ddragon.leagueoflegends.com/cdn/#{@version}/img/mastery/#{value['id']}.png"
        }
      end
      r
    end

  end

end