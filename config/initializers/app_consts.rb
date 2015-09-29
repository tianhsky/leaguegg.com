module AppConsts
  puts 'Setting up preferences'
  GAME_EXPIRES_THRESHOLD = 4.minutes
  FREE_ROTATION_EXPIRES_THRESHOLD = 3.hours
  RIOT_CONSTS_EXPIRES_THRESHOLD = 1.day
  CHAMPION_SEASON_STATS_EXPIRES_THRESHOLD = 1.day
  RECENT_MATCH_EXPIRES_THRESHOLD = 3.hours
  LEAGUE_EXPIRES_THRESHOLD = 5.minutes
  SUMMONER_EXPIRES_THRESHOLD = 1.day

  puts 'Seting up consts'
  HEALS_FACTOR = 1
  WARDP_FACTOR = 50
  WARDK_FACTOR = 100
  CCONTROL_FACTOR = 30

  puts 'Loading static data from riot'
  Consts::Version.setup
  Consts::Champion.setup
  Consts::Map.setup
  Consts::Mastery.setup
  Consts::Rune.setup
  Consts::Spell.setup
  Consts::GameQueue.setup
  Consts::Platform.setup
  ChampionService::Service.find_free_champions
end