profile_icon = Consts::Profile.find_by_id(profile_icon_id)

json.id profile_icon_id
json.img profile_icon['img']