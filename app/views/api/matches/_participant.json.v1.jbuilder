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

if participant['stats']
  json.stats do
    json.partial! 'api/matches/participant_stats', {stat: participant['stats']}
  end
end

if participant['stats_aggretated']
  json.stats_aggretated participant['stats_aggretated']
end

json.participant_id participant['participant_id']

if participant['timeline']
  json.player_role SummonerStats::PlayerRole.get_player_role(participant['timeline']['role'], participant['timeline']['lane'])
end

json.league_entry participant['league_entry']
