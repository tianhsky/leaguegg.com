server 'app1.nj.lolcaf.com:2223', roles: %w{app}, user: 'deployer'

set :rails_env, 'production'
set :branch, 'master'
set :deploy_to, "/home/deployer/srv/production/lolcaf"