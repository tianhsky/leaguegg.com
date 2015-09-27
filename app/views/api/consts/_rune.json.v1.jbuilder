rune = Consts::Rune.find_by_id(rune_id)

json.id rune_id
json.name rune['name']
json.description rune['description']
json.tier rune['tier']
json.type rune['type']
json.img rune['img']
