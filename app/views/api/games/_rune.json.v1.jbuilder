m = Consts::Rune.find_by_id(rune['rune_id'])

json.id m['id']
json.count rune['count']
json.name m['name']
json.description m['description']
json.tier m['tier']
json.type m['type']