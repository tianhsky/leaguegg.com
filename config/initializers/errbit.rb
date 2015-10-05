Airbrake.configure do |config|
  config.api_key = '714ed19df8a604ac7beab57ec2287ef6'
  config.host    = 'errbit.leaguegg.com'
  config.port    = 80
  config.secure  = config.port == 443
end