module SummonerService

  module Factory

    def self.build_summoner_hash(json, region)
      region.upcase!
      json['region'] = region
      json['summoner_id'] = json['id']
      json['riot_updated_at'] = json['revision_date']
      r = Utils::JsonParser.clone_to([
        'region', 'summoner_id', 'riot_updated_at', 'name',
        'profile_icon_id', 'summoner_level'
      ], json, {})
      r
    end

  end

end