module SummonerMatchService

  module Riot
    def self.find_matches(summoner_id, champion_id, region, begin_index, end_index)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/matchhistory/#{summoner_id}?championIds=#{champion_id}&beginIndex=#{begin_index}&endIndex=#{end_index}"
      resp = RiotAPI.get(url, region)
    end

    def self.find_recent_games(summoner_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v1.3/game/by-summoner/#{summoner_id}/recent"
      resp = RiotAPI.get(url, region)
    end

    def self.find_match(match_id, region)
      region = region.downcase
      url = "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/match/#{match_id}"
      resp = RiotAPI.get(url, region)
    end
  end

  module Factory
    def self.build_summoner_match_hash(json, participant_index)
      p = json['participants'][participant_index]
      pi = json['participant_identities'][participant_index]
      json['riot_created_at'] = json['match_creation']
      json.delete('match_creation')

      r = Utils::JsonParser.clone_to([
        'riot_created_at', 'season', 'region', 'platform_id',
        'match_mode', 'match_type', 'match_duration', 'queue_type',
        'map_id', 'match_version', 'match_id'
      ], json, {})

      if p
        Utils::JsonParser.clone_to([
          'team_id', 'spell1_id', 'spell2_id', 'champion_id', 'timeline',
          'highest_achieved_season_tier', 'masteries', 'stats'
        ], p, r)
        r['runes'] = p['runes'].map{|x|build_rune_hash(x)} if p['runes']
      end

      if pi
        r['participant_id'] = pi['participant_id']
        if pl = pi['player']
          Utils::JsonParser.clone_to([
            'summoner_id', 'summoner_name', 'profile_icon', 'match_history_uri'
          ], pl, r)
        end
      end
      r
    end

    def self.build_rune_hash(rune)
      rank = rune['rank'] || rune['count']
      {
        'rank' => rank,
        'rune_id' => rune['rune_id']
      }
    end

    def self.build_games_hash(json)
      r = json['games'].map do |g|
        {
          'game_id' => g['game_id'],
          'team_id' => g['team_id'],
          'champion_id' => g['champion_id'],
          'riot_created_at' => g['create_date']
        }
      end
      r
    end
  end

  module Service

    def self.find_match(summoner_id, match_id, region, game_hash=nil)
      region = region.downcase

      # find in db first
      match = SummonerMatch.where(match_id: match_id, summoner_id: summoner_id, region: region.upcase).first
      return match if match

      # if not found in db, find through api
      match_json = Riot::find_match(match_id, region)
      matches = []
      # store match for each summoner
      match_json['participants'].each_with_index do |p, index|
        if game_hash
          if p['teamId']==game_hash['team_id'] && p['championId']==game_hash['champion_id']
            # this is given summoner
            match_json['participantIdentities'][index]['player'] ||= {}
            pl = match_json['participantIdentities'][index]['player']
            pl['summonerId'] = summoner_id
          end
        end

        if pi = match_json['participantIdentities'][index]
          if pi['player']
            summoner_match_hash = Factory::build_summoner_match_hash(match_json, index)
            match = SummonerMatch.new(summoner_match_hash)
            match.save
            matches << match
          end
        end
      end

      matches.find{|m| m.summoner_id == summoner_id}
    end

    def self.find_matches(summoner_id, champion_id, region, begin_index, end_index)
      matches = []
      if matches_json = Riot::find_matches(summoner_id, champion_id, region, begin_index, end_index)['matches']
        matches_json.each do |mj|
          match = SummonerMatch.where(match_id: mj['match_id'], summoner_id: summoner_id, region: region.upcase).first
          unless match
            match_hash = Factory.build_summoner_match_hash(mj, 0)
            match = SummonerMatch.new(match_hash)
            match.save
          end
          matches << match
        end
      end
      matches
    end

    def self.find_recent_matches(summoner_id, region, reload)
      region = region.downcase
      if reload
        matches = []
        games_json = Riot::find_recent_games(summoner_id, region)
        games_hash = Factory::build_games_hash(games_json)
        games_hash.each do |g|
          game_id = g['game_id']
          begin
            match = Service::find_match(summoner_id, game_id, region, g)
            matches << match if match
          rescue Errors::NotFoundError => ex

          end
        end
      else
        matches = SummonerMatch.where(summoner_id: summoner_id, region: region.upcase).order_by(['riot_created_at', -1]).limit(15)
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