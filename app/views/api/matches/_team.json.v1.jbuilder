json.id team['team_id']

json.banned_champions team['banned_champions'] do |c|
  json.partial! 'api/consts/champion', {champion_id: c['champion_id']}
  json.pick_turn c['pick_turn']
end

json.participants team['participants'], partial: 'api/matches/participant', as: :participant
