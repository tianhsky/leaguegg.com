m = Consts::Mastery.find_by_id(mastery['mastery_id'])

json.id m['id']
json.rank mastery['rank']
json.name m['name']
json.description m['description'][mastery['rank']-1]