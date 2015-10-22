module SummonerStatService

  module Service

    def self.find_summoner_season_stats(summoner_id, region, reload_if_outdated=true, season=ENV['CURRENT_SEASON'])
      region.upcase!
      season = season.upcase
      # check db
      stats = SummonerStat.where({summoner_id: summoner_id, region: region, season: season}).first
      # check riot
      stats = SummonerStat.new unless stats
      
      if stats.new_record? || (reload_if_outdated && stats.outdated?)
        player_stats_json = nil
        # player_stats_json = Riot.find_summoner_player_stats(summoner_id, region, season)

        ranked_stats_json = nil
        ranked_stats_json = Riot.find_summoner_ranked_stats(summoner_id, region, season)
        season_stats_hash = Factory.build_season_stat_hash(ranked_stats_json, player_stats_json, summoner_id, season, region)
        stats.assign_attributes(season_stats_hash)
        stats.touch_synced_at
        stats.save
      end

      stats
    end

  end

end