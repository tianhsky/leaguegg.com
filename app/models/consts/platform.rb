module Consts

  module Platform

    @lock = Mutex.new

    def self.find_by_name(name)
      setup
      @data[name.upcase] || {}
    end

    def self.find_by_region(region)
      setup
      found = @data.find{|id,v|v['region'].upcase == region.upcase}
      found[1] || {}
    end

    def self.setup
      unless @data
        @lock.synchronize do
          @data ||= load_data
        end
      end
    end

    def self.load_data
      {
        'NA1' => { platform: 'NA1', region: 'NA' },
        'BR1' => { platform: 'BR1', region: 'BR' },
        'LA1' => { platform: 'LA1', region: 'LAN' },
        'LA2' => { platform: 'LA2', region: 'LAS' },
        'OC1' => { platform: 'OC1', region: 'OCE' },
        'EUN1' => { platform: 'EUN1', region: 'EUNE' },
        'TR1' => { platform: 'TR1', region: 'TR' },
        'RU' => { platform: 'RU', region: 'RU' },
        'EUW1' => { platform: 'EUW1', region: 'EUW' },
        'KR' => { platform: 'KR', region: 'KR' }
      }.with_indifferent_access
    end

  end

end