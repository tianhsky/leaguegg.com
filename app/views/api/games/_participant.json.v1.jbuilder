json.spell1 do
  json.partial! 'api/consts/spell', {spell_id: participant.spell1_id}
end

json.spell2 do
  json.partial! 'api/consts/spell', {spell_id: participant.spell2_id}
end

json.summoner do
  json.id participant.summoner_id
  json.name participant.summoner_name
end

json.champion do
  json.partial! 'api/consts/champion', {champion_id: participant.champion_id}
end

json.meta participant.meta

json.runes participant.runes do |r|
  json.partial! 'api/consts/rune', {rune_id: r['rune_id']}
  json.count r['count']
end

json.masteries participant.masteries do |m|
  json.partial! 'api/consts/mastery', {mastery_id: m['mastery_id'], rank: m['rank']}
end

if participant.ranked_stat_by_champion
  json.ranked_stat_overall do
    json.partial! 'ranked_stat_by_champion', {rstat: participant.ranked_stat_by_champion}
  end
else
  json.ranked_stat_overall nil
end

if participant.ranked_stat_by_recent_champion
  json.ranked_stat_recent do
    json.partial! 'ranked_stat_by_recent_champion', {rstat: participant.ranked_stat_by_recent_champion}
  end
else
  json.ranked_stat_recent nil
end