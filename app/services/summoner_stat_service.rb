module SummonerStatService

  module Riot

    def self.find_summoner_player_stats(summoner_id, region, season)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.3/stats/by-summoner/#{summoner_id}/summary?season=#{season.upcase}"
      resp = HttpService.get(url)
    end

    def self.find_summoner_ranked_stats(summoner_id, region, season)
      url = "https://#{region.downcase}.api.pvp.net/api/lol/#{region.downcase}/v1.3/stats/by-summoner/#{summoner_id}/ranked?season=#{season.upcase}"
      resp = HttpService.get(url)
    end

  end

  module Factory

    def self.build_season_stat_hash(rank_stats, player_stats, summoner_id, season, region)
      season.upcase!
      region.upcase!
      r = HashWithIndifferentAccess.new
      r['summoner_id'] = summoner_id
      r['season'] = season
      r['region'] = region
      if rank_stats
        rank_stats = rank_stats.with_indifferent_access
        rank_summary = rank_stats['champions'].select{|c|c['id']==0}.first
        # r['riot_updated_at'] = rank_stats['modifyDate']
        r['ranked_stats_by_champion'] = rank_stats['champions'].map{|c|build_ranked_stat_by_champion_hash(c)}.compact
        r['ranked_stat_summary'] = build_ranked_stat_summary_hash(rank_stats['modifyDate'], rank_summary)
      end
      if player_stats
        player_stats = player_stats.with_indifferent_access
        r['player_stats'] = player_stats['playerStatSummaries'].map{|p|build_player_stat_hash(p)}
      end
      r.with_indifferent_access
    end

    def self.build_ranked_stat_by_champion_hash(champ)
      champ = champ.with_indifferent_access
      champ_id = champ['id']
      return if champ_id == 0
      stat = champ['stats']
      {
        champion_id: champ_id,
        total_sessions_played: stat['totalSessionsPlayed'],
        total_sessions_lost: stat['totalSessionsLost'],
        total_sessions_won: stat['totalSessionsWon'],
        total_champion_kills: stat['totalChampionKills'],
        total_damage_dealt: stat['totalDamageDealt'],
        total_damage_taken: stat['totalDamageTaken'],
        most_champion_kills: stat['mostChampionKillsPerSession'],
        total_minion_kills: stat['totalMinionKills'],
        total_double_kills: stat['totalDoubleKills'],
        total_triple_kills: stat['totalTripleKills'],
        total_quadra_kills: stat['totalQuadraKills'],
        total_penta_kills: stat['totalPentaKills'],
        total_unreal_kills: stat['totalUnrealKills'],
        total_deaths: stat['totalDeathsPerSession'],
        total_gold_earned: stat['totalGoldEarned'],
        most_spells_cast: stat['mostSpellsCast'],
        total_turrets_killed: stat['totalTurretsKilled'],
        total_physical_damage_dealt: stat['totalPhysicalDamageDealt'],
        total_magic_damage_dealt: stat['totalMagicDamageDealt'],
        total_first_blood: stat['totalFirstBlood'],
        total_assists: stat['totalAssists'],
        max_champions_killed: stat['maxChampionsKilled'],
        max_num_deaths: stat['maxNumDeaths']
      }.with_indifferent_access
    end

    def self.build_ranked_stat_summary_hash(riot_updated_at, summary)
      summary = summary.with_indifferent_access
      stat = summary['stats']
      r = {}
      stat['riot_updated_at'] = riot_updated_at
      stat.each{ |k,v| r["#{k.to_s.underscore}"] = v }
      r.with_indifferent_access
    end

    def self.build_player_stat_hash(player_summary)
      player_summary = player_summary.with_indifferent_access
      stat = player_summary['aggregatedStats']
      new_stat = {}
      stat.each{ |k,v| new_stat["#{k.to_s.underscore}"] = v }
      {
        riot_updated_at: player_summary['modifyDate'],
        player_stat_summary_type: player_summary['playerStatSummaryType'],
        wins: player_summary['wins'],
        losses: player_summary['losses'],
        stats: new_stat
      }.with_indifferent_access
    end

  end

  module Service

    def self.find_summoner_season_stats(summoner_id, region, season=ENV['CURRENT_SEASON'])
      region.upcase!
      season = season.upcase
      # check db
      stats = SummonerStat.where({summoner_id: summoner_id, region: region, season: season}).first
      # check riot
      unless stats
        stats = SummonerStat.new
      end
      player_stats_json = nil
      # player_stats_json = Riot.find_summoner_player_stats(summoner_id, region, season)

      ranked_stats_json = nil
      ranked_stats_json = Riot.find_summoner_ranked_stats(summoner_id, region, season)

      season_stats_hash = Factory.build_season_stat_hash(ranked_stats_json, player_stats_json, summoner_id, season, region)
      stats.update_attributes(season_stats_hash)
      stats
    end

  end

end