module Utils
  module Time
    def self.time_to_epunix(time)
      return nil if time.blank?
      (time.to_f*1000).to_i if time
    end
    def self.epunix_to_time(epunix)
      return nil if epunix.blank?
      ::Time.at(epunix/1000)
    end
  end
end