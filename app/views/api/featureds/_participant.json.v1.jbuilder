json.bot participant['bot']

json.spell1 do
  json.partial! 'api/consts/spell', {spell_id: participant['spell1_id']}
end
json.spell2 do
  json.partial! 'api/consts/spell', {spell_id: participant['spell2_id']}
end
json.champion do
  json.partial! 'api/consts/champion', {champion_id: participant['champion_id']}
end
json.summoner do
  json.id participant['summoner_id']
  json.name participant['summoner_name']
end
json.profile_icon do
  json.partial! 'api/consts/profile_icon', {profile_icon_id: participant['profile_icon_id']}
end
