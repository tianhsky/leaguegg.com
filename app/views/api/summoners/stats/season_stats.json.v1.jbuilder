json.region @season_stats.region
json.season @season_stats.season
json.summoner_id @season_stats.summoner_id
json.ranked_stats_by_champion @season_stats.ranked_stats_by_champion, partial: 'ranked_stat_by_champion', as: :rstat