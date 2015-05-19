module Consts

  class Version < Consts::StaticData

    @lock = Mutex.new
    CACHE_KEY = 'static_versions'

    def self.current
      setup
      @data[0]
    end

    def self.setup
      begin
        setup_from_api
      rescue
        # setup_from_file
      end
    end

    def self.setup_from_api
      if local_cache_expired?
        unless @data = Rails.cache.read(CACHE_KEY)
          @lock.synchronize do
            @json = StaticDataService::Riot.fetch_versions
            @data = load_data
            Rails.cache.write(CACHE_KEY, @data, expires_in: AppConsts::RIOT_CONSTS_EXPIRES_THRESHOLD)
            @updated_at = Time.now
          end
        end
      end
    end

    def self.load_data
      r = @json
    end

  end

end