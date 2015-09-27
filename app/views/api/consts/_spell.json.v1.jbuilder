spell = Consts::Spell.find_by_id(spell_id)

json.id spell_id
json.name spell['name']
json.img spell['img']