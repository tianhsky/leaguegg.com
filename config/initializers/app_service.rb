module AppService

  puts 'Setting up limit'
  RIOT_THROTTLE = Ratelimit.new('riot_api_throttle', {:bucket_interval=>2})

end