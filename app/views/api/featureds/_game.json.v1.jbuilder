json.region game['region']
json.game_id game['game_id']
json.game_mode game['game_mode']
json.game_type game['game_type']
json.platform_id game['platform_id']
json.started_at game['started_at']
json.game_length game['game_length']
json.teams game['teams'] do |team|
  json.partial! 'team', {team: team}
end
json.map do
  json.partial! 'api/consts/map', {map_id: game['map_id']}
end
json.game_queue do
  json.partial! 'api/consts/game_queue', {game_queue_config_id: game['game_queue_config_id']}
end