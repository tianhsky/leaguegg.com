role :app, %w{www.lolcaf.com}

server 'www.lolcaf.com', roles: %w{app}, user: 'root'

set :rails_env, 'production'
set :branch, 'master'
set :deploy_to, "/srv/production/lolcaf1"