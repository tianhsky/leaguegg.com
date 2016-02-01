json.champion do
  json.partial! 'api/consts/champion', {champion_id: participant['champion_id']}
end

json.items