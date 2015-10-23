module AppConsts
  puts 'Setting up profile'
  SITE_TITLE = 'LeagueGG · League of Legends Search and Stats'
  SITE_DESCRIPTION = 'League GG · Find out how well your opponents farm, which roles they main, and how aggressive they play'
  SITE_KEYWORDS = ['leaguegg', 'league gg', 'lol gg', 'gg', 'good game', 'league of legends live', 'lol live game', 'lol stats']

  puts 'Setting up preferences'
  GAME_EXPIRES_THRESHOLD = 4.minutes
  FREE_ROTATION_EXPIRES_THRESHOLD = 3.hours
  RIOT_CONSTS_EXPIRES_THRESHOLD = 1.day
  CHAMPION_SEASON_STATS_EXPIRES_THRESHOLD = 1.hours
  RECENT_MATCH_EXPIRES_THRESHOLD = 1.hours
  LEAGUE_EXPIRES_THRESHOLD = 1.day
  SUMMONER_EXPIRES_THRESHOLD = 1.day

  puts 'Setting up versions'
  version = SemVer.find
  SERVER_VERSION = "#{version.major}.#{version.minor}.#{version.patch}"

  puts 'Setting up keys'
  WEB_API_SALT = 'f9242bd8f2e520cdd67ac5fe7f691495'
  MOBILE_API_KEY = 'lolcaf-mobile-apikey'

  puts 'Seting up consts'
  HEALS_FACTOR = 1
  WARDP_FACTOR = 50
  WARDK_FACTOR = 100
  CCONTROL_FACTOR = 30

  puts 'Setting up limit'
  RIOT_THROTTLE = Ratelimit.new('riot_api_throttle')
  FETCH_GAME_MAX_SECONDS = 16 #seconds

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