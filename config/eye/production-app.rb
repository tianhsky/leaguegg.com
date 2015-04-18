APP_NAME = 'lolcaf'
APP_ENV = 'production'

APP_ROOT = "/home/deployer/srv/#{APP_ENV}/#{APP_NAME}/current"
APP_SOCK = "tmp/sockets/puma.sock"
APP_PID = "tmp/pids/puma.pid"
APP_PUMA = "config/puma/production.rb"

Eye.application APP_NAME do
  working_dir APP_ROOT # path below can be relative to this
  load_env '.env' # global env for each processes
  if File.exist? File.join(APP_ROOT, 'Gemfile')
    clear_bundler_env
    # env "RAILS_ENV" => APP_ENV
    # env "PATH" => "/opt/rbenv/shims:/opt/rbenv/bin:#{ENV['PATH']}"
    # env "RBENV_ROOT" => "/opt/rbenv"
    # env "RBENV_VERSION" => File.read("#{APP_PATH}/.ruby-version").strip
    env 'BUNDLE_GEMFILE' => File.join(APP_ROOT, 'Gemfile')
  end

  process :puma do
    daemonize true
    pid_file APP_PID

    start_timeout 15.seconds
    stop_timeout 10.seconds
    restart_grace 15.seconds

    start_command "puma -C #{APP_PUMA}"
    stop_command "kill -s SIGTERM {PID}" # safe stop
    restart_command "kill -s SIGUSR1 {PID}" # phased restart

    monitor_children do
      restart_command "kill -s SIGTERM {PID}" # safe stop

      # each puma child process
      check :cpu, every: 15.seconds, below: 90, times: 3
      check :memory, every: 20.seconds, below: 1600.megabytes, times: [2, 5]
    end
  end

end
