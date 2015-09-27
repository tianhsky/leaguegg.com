
json.id @game.game_id
json.started_at @game.started_at

json.game_queue do
  json.partial! 'api/consts/game_queue', {game_queue_config_id: @game.game_queue_config_id}
end

json.map do
  json.partial! 'api/consts/map', {map_id: @game.map_id}
end

json.teams @game.teams, partial: 'team', as: :team