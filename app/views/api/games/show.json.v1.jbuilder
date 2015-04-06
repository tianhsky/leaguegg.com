
json.match do
  json.id @game.match_id
  json.mode @game.match_mode
  json.type @game.match_type
  json.started_at @game.started_at/1000
end

json.map do
  json.id @game.map_id
  json.name Consts::Map.find_by_id(@game.map_id)['name']
end

json.teams @game.match_teams, partial: 'team', as: :team