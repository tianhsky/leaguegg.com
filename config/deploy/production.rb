server 'app1.nj.leaguegg.com:2223', roles: %w{web app}, user: 'deployer'

set :rails_env, 'production'
set :branch, 'master'
set :deploy_to, "/home/deployer/srv/production/lolcaf"