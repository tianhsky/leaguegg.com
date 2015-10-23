host "www.leaguegg.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
  url rotation_url, last_mod: Time.now, change_freq: "weekly", priority: 0.7
  url mobile_url, last_mod: Time.now, change_freq: "weekly", priority: 0.5
end

sitemap_for Summoner, name: :summoners do |summoner|
  url summoner_search_url(summoner.region, "#{summoner.summoner_id}-#{summoner.name}"), last_mod: Time.now #last_mod: summoner.updated_at_time #, priority: 0.5
end

ping_with "http://#{host}/pub_sitemaps/index.xml"