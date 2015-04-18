ENV["BUNDLE_GEMFILE"] = "/srv/production/lolcaf1/current/Gemfile"

env = 'production'
environment env
daemonize false
workers 5
threads 0, 20

bind  "unix:///srv/production/lolcaf1/shared/tmp/sockets/puma.sock"
pidfile "tmp/pids/puma.pid"
state_path "tmp/pids/puma.state"
stdout_redirect "log/#{env}.out.log", "log/#{env}.err.log", true

prune_bundler
activate_control_app
