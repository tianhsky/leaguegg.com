module Consts

  class StaticData

    def self.local_cache_expired?
      !@data || @updated_at && @updated_at < Time.now - AppConsts::RIOT_CONSTS_EXPIRES_THRESHOLD
    end

  end

end