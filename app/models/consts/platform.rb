module Consts

  class Platform < Consts::StaticData

    @lock = Mutex.new

    def self.find_by_name(name)
      setup
      @data[name.upcase] || {}
    end

    def self.find_by_region(region)
      setup
      found = @data.find{|id,v|v['region'].upcase == region.upcase}
      found ? found[1] : {}
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
        'NA1' => { 'platform' => 'NA1', 'region' => 'NA', 'name' => 'North America' },
        'BR1' => { 'platform' => 'BR1', 'region' => 'BR' , 'name' => 'Brazil'},
        'LA1' => { 'platform' => 'LA1', 'region' => 'LAN', 'name' => 'Latin America North' },
        'LA2' => { 'platform' => 'LA2', 'region' => 'LAS', 'name' => 'Latin America North' },
        'OC1' => { 'platform' => 'OC1', 'region' => 'OCE', 'name' => 'Oceania' },
        'EUN1' => { 'platform' => 'EUN1', 'region' => 'EUNE', 'name' => 'Europe Nordic & East' },
        'TR1' => { 'platform' => 'TR1', 'region' => 'TR', 'name' => 'Turkey' },
        'RU' => { 'platform' => 'RU', 'region' => 'RU', 'name' => 'Russia' },
        'EUW1' => { 'platform' => 'EUW1', 'region' => 'EUW', 'name' => 'Europe West' },
        'KR' => { 'platform' => 'KR', 'region' => 'KR', 'name' => 'Republic of Korea' }
      }
    end

  end

end