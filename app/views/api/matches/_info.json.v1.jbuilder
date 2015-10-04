json.id match.match_id
json.season match.season
json.region match.region

json.queue_type match.queue_type
json.match_mode match.match_mode
json.match_type match.match_type
json.match_duration match.match_duration
json.match_version match.match_version
json.timeline match.timeline
json.created_at match.riot_created_at
json.stats match.stats

json.summoner do
  json.id match.summoner_id
  json.name match.summoner_name
end
json.map do
  json.partial! 'api/consts/map', {map_id: match.map_id}
end
json.runes match.runes do |r|
  json.partial! 'api/consts/rune', {rune_id: r['rune_id']}
  json.count r['count']
end
json.masteries match.masteries do |m|
  json.partial! 'api/consts/mastery', {mastery_id: m['mastery_id'], rank: m['rank']}
end
json.spell1 do
  json.partial! 'api/consts/spell', {spell_id: match.spell1}
end
json.spell2 do
  json.partial! 'api/consts/spell', {spell_id: match.spell2}
end
