module MatchService

  module Factory

    def self.build_match_hash(match_json)
      match_json['riot_created_at'] = match_json['match_creation']
      match_json.delete('match_creation')
      build_teams_hash(match_json)
      r = Utils::JsonParser.clone_to([
        'match_id', 'season', 'region', 'platform_id', 'match_mode',
        'match_type', 'riot_created_at', 'match_duration', 'map_id',
        'match_version', 'queue_type', 'teams', 'timeline'
      ], match_json, {})
      r
    end

    def self.build_teams_hash(match_json)
      grouped_participants = match_json['participants'].group_by{|p| p['team_id']}
      grouped_participants.each do |team_id, participants|
        participants.each do |par|
          pl = match_json['participant_identities'].find{|p| p['participant_id'] == par['participant_id']}
          if pl = pl['player']
            par['summoner_id'] = pl['summoner_id']
            par['summoner_name'] = pl['summoner_name']
            par['profile_icon'] = pl['profile_icon']
            par['match_history_uri'] = pl['match_history_uri']
          end
        end
        team = match_json['teams'].find{|t|t['team_id'].to_s == team_id.to_s}
        team['banned_champions'] = team['bans']
        team.delete('bans')
        team['participants'] = participants
      end
      nil
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
      result.sort_by!{|r|-(r['games'].to_i)}
      result
    end

    def self.best_kills(stats)
      return 'Penta Kill' if stats['penta_kills'] != 0
      return 'Quadra Kill' if stats['quadra_kills'] != 0
      return 'Triple Kill' if stats['triple_kills'] != 0
      return 'Double Kill' if stats['double_kills'] != 0
      nil
    end

    def self.kda(stats)
      r = nil
      ka = stats['kills'] + stats['assists']
      d = stats['deaths']
      if ka!=0 && d!=0
        r = (ka.to_f / d).round(2)
      end
      r
    end

    def self.timeline_json_to_array(timeline_json)
      return [] if timeline_json.blank?
      arr = []
      arr[0] = timeline_json['zero_to_ten'] || 0
      arr[1] = timeline_json['ten_to_twenty'] || 0
      arr[2] = timeline_json['twenty_to_thirty'] || 0
      arr[3] = timeline_json['thirty_to_end'] || 0
      arr
    end

    def self.plus_timeline_arr(sum_timeline_arr, timeline_arr)
      4.times do |t|
        sum_timeline_arr[t] ||= 0
        sum_timeline_arr[t] += timeline_arr[t] || 0
      end
      sum_timeline_arr
    end

    def self.build_match_players_json(recent_match, summoner_id)
      return unless recent_match
      summoner_id = summoner_id.to_i
      current_summoner = {
        'summoner_id' => summoner_id,
        'champion_id' => recent_match['champion_id'],
        'team_id' => recent_match['team_id']
      }
      recent_match['fellow_players'] |= [current_summoner]
      recent_match['fellow_players']
    end

  end

end