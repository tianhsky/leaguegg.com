map = Consts::Map.find_by_id(map_id)

json.id map_id
json.name map['name']