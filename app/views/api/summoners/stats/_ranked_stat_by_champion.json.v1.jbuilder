json.champion do
  json.partial! 'api/consts/champion', {champion_id: rstat.champion_id}
end

json.games rstat.total_sessions_played
json.won rstat.total_sessions_won
json.lost rstat.total_sessions_lost

json.avg_kills rstat.avg_kills
json.avg_deaths rstat.avg_deaths
json.avg_assists rstat.avg_assists

json.aggresive_rate rstat.aggresive_rate
json.win_rate rstat.win_rate
json.kda_rate rstat.kda_rate
