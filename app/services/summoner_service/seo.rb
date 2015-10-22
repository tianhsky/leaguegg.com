module SummonerService

  module SEO

    def self.meta_description(summoner)
      league = summoner.primary_league
      description = "#{summoner.name}'s League of Legends Stats, Level #{summoner.summoner_level}, #{summoner.region_name}"
      description += ", #{league['tier']} #{league['division']} in #{league['name']}" if league
      description
    end

  end

end