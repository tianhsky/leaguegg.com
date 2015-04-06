json.spell1 do
  json.id participant.spell1_id
  json.name Consts::Spell.find_by_id(participant.spell1_id)['name']
end

json.spell2 do
  json.id participant.spell2_id
  json.name Consts::Spell.find_by_id(participant.spell2_id)['name']
end

json.summoner do
  json.id participant.summoner_id
  json.name participant.summoner_name
end

json.champion do
  json.id participant.champion_id
  json.name Consts::Champion.find_by_id(participant.champion_id)['name']
end

ranked_stat = participant.summoner_ranked_stat
json.ranked_stat do
  json.offensive_rate ranked_stat.try(:offensive_rate)
  json.defensive_rate ranked_stat.try(:defensive_rate)
  json.cs_rate ranked_stat.try(:cs_rate)
  json.win_rate ranked_stat.try(:win_rate)
  json.avg_kills ranked_stat.try(:avg_kills)
  json.avg_deaths ranked_stat.try(:avg_deaths)
  json.avg_assists ranked_stat.try(:avg_assists)
end