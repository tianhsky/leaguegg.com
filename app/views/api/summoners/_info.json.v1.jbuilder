json.id summoner.summoner_id
json.name summoner.name
json.region summoner.region
json.region_name summoner.region_name
json.meta_description SummonerService::SEO.meta_description(summoner)
json.level summoner.summoner_level
json.profile_icon do
  json.partial! 'api/consts/profile_icon', {profile_icon_id: summoner.profile_icon_id}
end
json.league_entries summoner.league_entries