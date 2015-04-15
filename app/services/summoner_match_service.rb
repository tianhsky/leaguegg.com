module SummonerMatchService

  module Riot
    def self.find_recent_matches(summoner_id, champion_id, region)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v2.2/matchhistory/#{summoner_id}?championIds=#{champion_id}&beginIndex=0&endIndex=15"
      resp = HttpService.get(url)
    end
  end

  module Factory
    def self.build_match_hash(json)
      p = json['participants'][0]
      pi = json['participantIdentities'][0]
      pl = pi['player']

      r = HashWithIndifferentAccess.new
      r['riot_created_at'] = json['matchCreation']
      r['season'] = json['season']
      r['region'] = json['region']
      r['platform_id'] = json['platformId']
      r['match_mode'] = json['matchMode']
      r['match_type'] = json['matchType']
      r['match_duration'] = json['matchDuration']
      r['queue_type'] = json['queueType']
      r['map_id'] = json['mapId']
      r['match_version'] = json['matchVersion']
      r['team_id'] = p['teamId']
      r['spell1_id'] = p['spell1Id']
      r['spell2_id'] =p['spell2Id']
      r['highest_achieved_season_tier'] = p['highestAchievedSeasonTier']
      r['masteries'] = p['masteries'].map{|x|build_mastery_hash(x)} if p['masteries']
      r['runes'] = p['runes'].map{|x|build_rune_hash(x)} if p['runes']
      r['timeline'] = build_time_line_hash(p['timeline'])
      r['stats'] = build_stats_hash(p['stats'])
      r['participant_id'] = pi['participantId']
      r['match_id'] = json['matchId']
      r['summoner_id'] = pl['summonerId']
      r['summoner_name'] = pl['summonerName']
      r['profile_icon'] = pl['profileIcon']
      r['match_history_uri'] = pl['matchHistoryUri']
      r
    end

    def self.build_mastery_hash(mastery)
      mastery = mastery.with_indifferent_access
      {
        rank: mastery['rank'],
        mastery_id: mastery['masteryId']
      }.with_indifferent_access
    end

    def self.build_rune_hash(rune)
      rune = rune.with_indifferent_access
      {
        rank: rune['count'],
        rune_id: rune['runeId']
      }.with_indifferent_access
    end

    def self.build_time_line_hash(time_line_json)
      time_line_json = time_line_json.with_indifferent_access
      r = {}
      time_line_json.each do |k,v|
        rv = {}
        if v.is_a? String
          r["#{k.to_s.underscore}"] = v
        else
          v.each{|vk, vv| rv["#{vk.to_s.underscore}"] = vv }
          r["#{k.to_s.underscore}"] = rv
        end
      end
      r.with_indifferent_access
    end

    def self.build_stats_hash(stats_json)
      stats_json = stats_json.with_indifferent_access
      r = {}
      stats_json.each do |k,v|
        r["#{k.to_s.underscore}"] = v
      end
      r.with_indifferent_access
    end
  end

  module Service
    def self.find_recent_matches(summoner_id, champion_id, region)
      matches = []
      if matches_json = Riot::find_recent_matches(summoner_id, champion_id, region)['matches']
        matches_json.each do |mj|
          match = SummonerMatch.where(match_id: mj['matchId'], summoner_id: summoner_id, region: region).first
          unless match
            match_hash = Factory.build_match_hash(mj)
            match = SummonerMatch.new(match_hash)
            match.save
          end
          matches << match
        end
      end
      matches
    end

    def self.get_matches_aggregation(matches, champion_id)
      return nil if matches.empty?
      stats = SummonerStats::RankedStatByRecentChampion.new
      stats.champion_id = champion_id
      stats.games = matches.count
      matches.each do |m|
        stat = m.stats
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
        if timeline = m.timeline
          stats.per_min_cs_at_10m += timeline.try(:[],'creeps_per_min_deltas').try(:[],'zero_to_ten') || 0
          stats.per_min_dmg_taken_at_10m += timeline.try(:[],'damage_taken_per_min_deltas').try(:[],'zero_to_ten') || 0
        end
      end
      stats
    end
  end

end