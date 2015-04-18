server 'www.lolcaf.com', roles: %w{app}, user: 'deployer'

set :rails_env, 'production'
set :branch, 'master'
set :deploy_to, "/home/deployer/srv/production/lolcaf"