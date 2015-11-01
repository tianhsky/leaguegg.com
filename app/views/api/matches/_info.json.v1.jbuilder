json.id match.match_id
json.season match.season
json.region match.region

json.queue_type match.queue_type
json.match_mode match.match_mode
json.match_type match.match_type
json.match_duration match.match_duration
json.match_version match.match_version
json.created_at match.riot_created_at

json.teams match.teams, partial: 'api/matches/team', as: :team
#json.summoner_ids match.summoner_ids

if !@exclude_timeline
  if match.timeline
    json.timeline do
      json.partial! 'api/matches/timeline', {timeline: match.timeline}
    end
  end
end

json.map do
  json.partial! 'api/consts/map', {map_id: match.map_id}
end

