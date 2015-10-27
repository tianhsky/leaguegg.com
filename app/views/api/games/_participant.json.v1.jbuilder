json.spell1 do
  json.partial! 'api/consts/spell', {spell_id: participant['spell1_id']}
end

json.spell2 do
  json.partial! 'api/consts/spell', {spell_id: participant['spell2_id']}
end

json.summoner do
  json.id participant['summoner_id']
  json.name participant['summoner_name']
end

json.champion do
  json.partial! 'api/consts/champion', {champion_id: participant['champion_id']}
end

json.meta participant['meta']

json.runes participant['runes'] do |r|
  json.partial! 'api/consts/rune', {rune_id: r['rune_id']}
  json.count r['count']
end

json.masteries participant['masteries'] do |m|
  json.partial! 'api/consts/mastery', {mastery_id: m['mastery_id'], rank: m['rank']}
end

if participant['ranked_stat_by_champion']
  json.ranked_stat_overall do
    json.partial! 'api/games/ranked_stat_by_champion', {rstat: participant['ranked_stat_by_champion']}
  end
else
  json.ranked_stat_overall nil
end

if participant['ranked_stat_by_recent_champion']
  json.ranked_stat_recent do
    json.partial! 'api/games/ranked_stat_by_recent_champion', {rstat: participant['ranked_stat_by_recent_champion']}
  end
else
  json.ranked_stat_recent nil
end

if participant['stats']
  json.stats do
    json.partial! 'api/matches/participant_stats', {stat: participant['stats']}
  end
end

json.player_role SummonerStats::PlayerRole.get_player_role(participant['timeline']['role'], participant['timeline']['lane'])

json.league_entry participant['league_entry']

json.player_roles participant['player_roles']