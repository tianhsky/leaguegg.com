module Consts

  class Profile < Consts::StaticData

    @lock = Mutex.new
    CACHE_KEY = 'static_profile'

    def self.find_by_id(id)
      @version = Consts::Version.current
      r = {
        "id" => id.try(:to_i),
        "img" => "http://ddragon.leagueoflegends.com/cdn/#{@version}/img/profileicon/#{id}.png"
      }
    end

  end

end