champion = Consts::Champion.find_by_id(champion_id)

json.id champion_id
json.name champion['name']
json.img champion['img']
json.img_loading champion['img_loadings'].try(:first)
json.img_splash champion['img_splashes'].try(:first)