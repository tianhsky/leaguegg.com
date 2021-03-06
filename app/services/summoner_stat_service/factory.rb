module SummonerStatService

  module Factory

    def self.build_season_stat_hash(rank_stats, player_stats, summoner_id, season, region)
      season.upcase!
      region.upcase!

      r = {}
      r['summoner_id'] = summoner_id
      r['season'] = season
      r['region'] = region
      if rank_stats
        rank_summary = rank_stats['champions'].select{|c|c['id']==0}.first
        r['ranked_stat_summary'] = build_ranked_stat_summary_hash(rank_stats['modify_date'], rank_summary)
        r['ranked_stats_by_champion'] = rank_stats['champions'].map{|c|build_ranked_stat_by_champion_hash(c)}.compact
      end
      if player_stats
        r['player_stats'] = player_stats['player_stat_summaries'].map{|p|build_player_stat_hash(p)}
      end
      r
    end

    def self.build_ranked_stat_by_champion_hash(champ)
      champ_id = champ['id']
      return if champ_id == 0 # do not build for overall stats
      champ.delete('id')

      stat = champ['stats']
      stat['champion_id'] = champ_id
      stat
    end

    def self.build_ranked_stat_summary_hash(riot_updated_at, summary)
      stat = summary['stats']
      stat['riot_updated_at'] = riot_updated_at
      stat
    end

    def self.build_player_stat_hash(player_summary)
      stat = player_summary['aggregated_stats']
      r = Utils::JsonParser.clone_to([
        'player_stat_summary_type', 'wins', 'losses'
      ], player_summary, {})
      r['riot_updated_at'] = player_summary['modify_date']
      r['stats'] = stat
      r
    end

  end

end