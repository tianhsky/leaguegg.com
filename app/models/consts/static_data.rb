module Consts

  class StaticData

    def self.local_cache_expired?
      not_expired = @data && @updated_at && @updated_at >= Time.now - AppConsts::RIOT_CONSTS_EXPIRES_THRESHOLD
      !not_expired
    end

  end

end