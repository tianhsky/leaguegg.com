json.team_id team['team_id']
json.banned_champions team['banned_champions'] do |c|
  json.partial! 'api/consts/champion', {champion_id: c['champion_id']}
  json.pick_turn c['pick_turn']
end
json.participants team['participants'] do |p|
  json.partial! 'participant', {participant: p}
end