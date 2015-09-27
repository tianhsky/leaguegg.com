queue = Consts::GameQueue.find_by_id(game_queue_config_id)

json.id game_queue_config_id
json.name queue['name'] 