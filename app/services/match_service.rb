module MatchService

  module Riot
    def self.find_match(match_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/match/#{match_id}"
      resp = ::RiotAPI.get(url, region)
    end

    def self.find_match_list(summoner_id, region, season=ENV['CURRENT_SEASON'], champion_id=nil, begin_index=nil, end_index=nil)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/matchlist/by-summoner/#{summoner_id}?"
      url += "&seasons=#{season}" unless season.blank?
      url += "&championIds=#{champion_id}" unless champion_id.blank?
      url += "&beginIndex=#{begin_index}" unless begin_index.blank?
      url += "&endIndex=#{end_index}" unless end_index.blank?
      resp = ::RiotAPI.get(url, region)
    end

    def self.find_recent_matches(summoner_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v1.3/game/by-summoner/#{summoner_id}/recent"
      resp = ::RiotAPI.get(url, region)
    end
  end

  module Factory

    def self.build_match_hash(match_json)
      match_json['riot_created_at'] = match_json['match_creation']
      match_json.delete('match_creation')
      build_teams_hash(match_json)
      r = Utils::JsonParser.clone_to([
        'match_id', 'season', 'region', 'platform_id', 'match_mode',
        'match_type', 'riot_created_at', 'match_duration', 'map_id',
        'match_version', 'queue_type', 'teams'
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

  end

  module Service

    def self.find_match(match_id, region)
      params = {match_id: match_id, region: region.upcase}
      # find in db first
      match = Match.where(params).first
      return match if match

      # if not found in db, find through api
      match_json = Riot.find_match(match_id, region)
      match_hash = Factory.build_match_hash(match_json)
      match = Match.new(match_hash)
      Thread.new do
        begin
          if match.new_record?
            match.save
          end
        rescue
        end
      end

      match
    end

    def self.get_matches_aggregation_for_matches(matches, summoner_id)
      participants = matches.map{|m|m.find_match_stats_for_summoner(summoner_id)}
      self.get_matches_aggregation_for_participants(participants)
    end

    def self.get_matches_aggregation_for_participants(participants)
      return nil if participants.empty?
      stats = SummonerStats::RankedStatByRecentChampion.new
      stats.games = participants.count
      participants.each do |m|
        next if m.blank?
        stats.champion_id = m['champion_id']
        if stat = m['stats']
          stats.won += 1 if stat['winner']
          stats.lost +=1 unless stat['winner']
          stats.double_kills += stat['double_kills']
          stats.triple_kills += stat['triple_kills']
          stats.quadra_kills += stat['quadra_kills']
          stats.penta_kills += stat['penta_kills']
          stats.team_jungle_kills += stat['neutral_minions_killed_team_jungle']
          stats.enemy_jungle_kills += stat['neutral_minions_killed_enemy_jungle']
          stats.minion_kills += stat['minions_killed']
          stats.kills += stat['kills']
          stats.deaths += stat['deaths']
          stats.assists += stat['assists']
          stats.physical_to_champion += stat['physical_damage_dealt_to_champions']
          stats.magic_to_champion += stat['magic_damage_dealt_to_champions']
          stats.true_to_champion += stat['true_damage_dealt_to_champions']
          stats.heals += stat['total_heal']
          stats.wards_placed += stat['wards_placed']
          stats.wards_killed += stat['wards_killed']
          stats.sight_wards_bought += stat['sight_wards_bought_in_game']
        end
        if timeline = m['timeline']
          timeline_gold = timeline.try(:[],'gold_per_min_deltas')
          timeline_cs = timeline.try(:[],'creeps_per_min_deltas')
          timeline_csd = timeline.try(:[],'cs_diff_per_min_deltas')
          timeline_xp = timeline.try(:[],'xp_per_min_deltas')
          timeline_xpd = timeline.try(:[],'xp_diff_per_min_deltas')
          timeline_dmgt = timeline.try(:[],'damage_taken_per_min_deltas')
          timeline_dmgtd = timeline.try(:[],'damage_taken_diff_per_min_deltas')

          timeline_gold_arr = Factory.timeline_json_to_array(timeline_gold)
          timeline_cs_arr = Factory.timeline_json_to_array(timeline_cs)
          timeline_csd_arr = Factory.timeline_json_to_array(timeline_csd)
          timeline_xp_arr = Factory.timeline_json_to_array(timeline_xp)
          timeline_xpd_arr = Factory.timeline_json_to_array(timeline_xpd)
          timeline_dmgt_arr = Factory.timeline_json_to_array(timeline_dmgt)
          timeline_dmgtd_arr = Factory.timeline_json_to_array(timeline_dmgtd)

          Factory.plus_timeline_arr(stats.timeline_cs, timeline_cs_arr)
          Factory.plus_timeline_arr(stats.timeline_csd, timeline_csd_arr)
          Factory.plus_timeline_arr(stats.timeline_xp, timeline_xp_arr)
          Factory.plus_timeline_arr(stats.timeline_xpd, timeline_xpd_arr)
          Factory.plus_timeline_arr(stats.timeline_dmgt, timeline_dmgt_arr)
          Factory.plus_timeline_arr(stats.timeline_dmgtd, timeline_dmgtd_arr)

          stats.per_min_gold_at_10m += timeline_gold_arr[0]||0
          stats.per_min_cs_at_10m += timeline_cs_arr[0]||0
          stats.per_min_cs_diff_at_10m += timeline_csd_arr[0]||0
          stats.per_min_dmg_taken_at_10m += timeline_dmgt_arr[0]||0
          stats.per_min_dmg_taken_diff_at_10m += timeline_dmgtd_arr[0]||0
        end
      end
      stats.aggregate_stats
      stats
    end



    def self.find_recent_matches(summoner_id, region, reload)
      region = region.upcase
      if reload
        matches = []
        workers = []
        workers << Thread.new do
          matches_json = Riot.find_recent_matches(summoner_id, region)
          matches_json['games'].each do |match_json|
            match_id = match_json['game_id']
            match = Service.find_match(match_id, region)
            matches << match if match
          end
        end
        workers.map(&:join)
      else
        matches = Match.where('teams.participants.summoner_id':summoner_id, 'region':region).order_by(['riot_created_at', -1]).limit(15)
      end
      matches
    end

    def self.get_matches_aggregation_for_last_x_matches(region, summoner_id, champion_id, x=3, prefetched_match_list=[])
      begin
        # last match
        last_matches_json = prefetched_match_list.select{|m|m['champion'].try(:to_i) == champion_id.to_i}
        last_x_matches = last_matches_json.take(x)

        if last_x_matches.blank?
          champion_match_list_json = MatchService::Riot.find_match_list(summoner_id, region, ENV['CURRENT_SEASON'], champion_id.to_i, 0, x)
          last_x_matches = champion_match_list_json['matches'].try(:take, x)
        end
        if !last_x_matches.blank?
          match_items = []
          workers = []
          last_x_matches.each do |match_list_item|
            workers << Thread.new do
              begin
                match_item = MatchService::Service.find_match(match_list_item['match_id'], region)
                match_items << match_item
              rescue
              end
            end
          end
          workers.map(&:join)

          return self.get_matches_aggregation_for_matches(match_items, summoner_id)
        end
        rescue => ex
          begin
            Airbrake.notify_or_ignore(ex,
            parameters: {
              'action' => 'Generate recent stats for matches'
            })
          rescue
          end
      end
    end

  end

end