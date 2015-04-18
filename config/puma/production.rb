env = 'production'
app_path = "/home/deployer/srv/#{env}/lolcaf"
ENV["BUNDLE_GEMFILE"] = "#{app_path}/current/Gemfile"

environment env
daemonize false
workers 5
threads 0, 20

bind  "unix://#{app_path}/shared/tmp/sockets/puma.sock"
pidfile "tmp/pids/puma.pid"
state_path "tmp/pids/puma.state"
stdout_redirect "log/#{env}.out.log", "log/#{env}.err.log", true

prune_bundler
activate_control_app
