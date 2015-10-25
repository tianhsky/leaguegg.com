env = 'production'
app_path = File.expand_path("../../", Dir.pwd)

environment env
daemonize false
workers 3
threads 0, 50
prune_bundler

bind  "unix://#{app_path}/shared/tmp/sockets/puma.sock"
pidfile "tmp/pids/puma.pid"
state_path "tmp/pids/puma.state"
stdout_redirect "log/#{env}.out.log", "log/#{env}.err.log", true

# activate_control_app
