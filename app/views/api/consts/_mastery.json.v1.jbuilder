mastery = Consts::Mastery.find_by_id(mastery_id)

json.id mastery_id
json.name mastery['name']
json.img mastery['img']

if rank
  json.description mastery['description'][rank-1]
  json.rank rank
end