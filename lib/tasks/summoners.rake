namespace :summoners do
  namespace :all do
    task :sync => :environment do
      desc "Sync all summoners"
      ::Summoner.no_timeout.each do |summoner|
        begin
          summoner.sync_from_riot!
        rescue
        end
      end
    end
  end

  namespace :masters do
    task :fetch => :environment do
      desc "Fetch master summoners"
      type = 'RANKED_SOLO_5x5'
      region = 'na'
      league = ::LeagueService::Riot.find_master_league(region, type)
      league['entries'].each do |e|
        begin
          summoner = ::SummonerService::Service.find_summoner_by_summoner_id(e['player_or_team_id'], region)
          summoner.sync_from_riot!
          puts "Synced #{summoner.name}"
        rescue
        end
      end
    end
  end

  namespace :challengers do
    task :fetch => :environment do
      desc "Fetch challenger summoners"
      type = 'RANKED_SOLO_5x5'
      region = 'na'
      league = ::LeagueService::Riot.find_challenger_league(region, type)
      league['entries'].each do |e|
        begin
          summoner = ::SummonerService::Service.find_summoner_by_summoner_id(e['player_or_team_id'], region)
          summoner.sync_from_riot!
          puts "Synced #{summoner.name}"
        rescue
        end
      end
    end
  end
end