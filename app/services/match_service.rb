module MatchService

  module Riot
    def self.find_match(match_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/match/#{match_id}"
      resp = RiotAPI.get(url, region)
    end

    def self.find_match_list(summoner_id, region, season=ENV['CURRENT_SEASON'], champion_id=nil, begin_index=nil, end_index=nil)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/matchlist/by-summoner/#{summoner_id}?"
      url += "&seasons=#{season}" if season
      url += "&championIds=#{champion_id}" if champion_id
      url += "&beginIndex=#{begin_index}" if begin_index
      url += "&endIndex=#{end_index}" if end_index
      resp = RiotAPI.get(url, region)
    end
  end

  module Factory

    def self.build_match_hash(match_json)
      r = Utils::JsonParser.clone_to([
        'match_id', 'season', 'region', 'platform_id', 'match_mode',
        'match_type', 'riot_created_at', 'match_duration', 'map_id',
        'match_version', 'teams'
        ], match_json, {})
    end

    # ??? to do sanitize
    def self.build_teams_hash(match_json)
      grouped_participants = match_json['participants'].group_by{|p| p['team_id']}
      grouped_participants.each do |k, v|
        pl = match_json['participant_identities'].find{|p| p['participant_id']== v['participant_id']}
        v['summoner_id'] = pl['summoner_id']
        v['summoner_name'] = pl['summoner_name']
        v['profile_icon'] = pl['profile_icon']
        v['match_history_uri'] = pl['match_history_uri']
      end
      
    end

    def self.build_player_roles(match_list_json)
      result = []
      matches = match_list_json['matches']
      unless matches.blank?
        grouped_roles = matches.group_by{|m| {'lane' => m['lane'], 'role' => m['role']}}
        grouped_roles.each do |k, v|
          k['games'] = v.count
          result << k
        end
      end
      result
    end

    def self.get_match_list_for(match_list_json, champion_id, count)
      matches = match_list_json['matches']
      unless matches.blank?
        found = matches.select{|m| m.champion.to_i == champion_id.to_i}.take(count)
        result = found.map do |m|
          {
            'platform_id' => m['platformId'],
            'match_id' => m['matchId'],
            'champion_id' => m['champion'],
            'queue' => m['queue'],
            'season' => m['season'],
            'timestamp' => m['timestamp'],
            'lane' => m['lane'],
            'role' => m['role']
          }
        end
        return result
      end
    end

  end

  module Service

    def self.find_match(match_id, region)
      # find in db first
      match = Match.where(match_id: match_id, region: region.upcase).first
      return match if match

      # if not found in db, find through api
      match_json = Riot.find_match(match_id, region)
      match_hash = Factory.build_match_hash(match_json, region)
      match = Match.create(match_hash)
    end

    def self.get_match_aggregation(match)

    end


  end

end