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

if participant.ranked_stat_by_champion
  json.ranked_stat_overall do
    json.partial! 'ranked_stat_by_champion', rstat: participant.ranked_stat_by_champion
  end
else
  json.ranked_stat_overall nil
end

if participant.ranked_stat_by_recent_champion
  json.ranked_stat_recent do
    json.partial! 'ranked_stat_by_recent_champion', rstat: participant.ranked_stat_by_recent_champion
  end
else
  json.ranked_stat_recent nil
end