
json.id @game.game_id
json.started_at @game.started_at

json.game_queue do
  json.id @game.game_queue_config_id
  json.name Consts::GameQueue.find_by_id(@game.game_queue_config_id)['name'] 
end

json.map do
  json.id @game.map_id
  json.name Consts::Map.find_by_id(@game.map_id)['name']
end

json.teams @game.teams, partial: 'team', as: :team