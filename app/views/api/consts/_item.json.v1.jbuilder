item = Consts::Item.find_by_id(item_id)

json.id item_id
json.name item['name']
json.img item['img']