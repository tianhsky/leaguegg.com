json.id @match.match_id
json.season @match.season
json.region @match.region

json.queue_type @match.queue_type
json.match_mode @match.match_mode
json.match_type @match.match_type
json.match_duration @match.match_duration
json.match_version @match.match_version
json.created_at @match.riot_created_at

json.teams @match.teams, partial: 'api/matches/team', as: :team

json.timeline @match.timeline

json.map do
  json.partial! 'api/consts/map', {map_id: @match.map_id}
end

