json.id team.team_id

json.banned_champions team.banned_champions do |c|
  json.id c['champion_id']
  json.name Consts::Champion.find_by_id(c['champion_id'])['name']
  json.pick_turn c['pick_turn']
end

json.participants team.participants, partial: 'participant', as: :participant
