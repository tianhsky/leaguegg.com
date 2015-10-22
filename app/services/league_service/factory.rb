module LeagueService

  module Factory

    def self.build_league_hash(json, region)
      return if json.blank?
      region = region.upcase
      if json.is_a? Array
        r = json.map{|x| build_league_hash(x, region)}
      else
        r = json
        r.delete('participant_id')
        r['region'] = region
      end
      r
    end

  end

end