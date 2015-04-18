# Prerequisit
# rvm wrapper current lolcaf bundle

APP_NAME = 'lolcaf1'
APP_ENV = 'production'
BUNDLE_PATH = '/usr/local/rvm/bin/lolcaf_bundle'

APP_ROOT = "/srv/#{APP_ENV}/#{APP_NAME}/current"
APP_SOCK = File.join(APP_ROOT, "tmp/sockets/puma.sock")
APP_PID = File.join(APP_ROOT, "tmp/pids/puma.pid")
PUMA_PATH = File.join(APP_ROOT, 'config/puma/production.rb')

Eye.application APP_NAME do
  env APP_ENV # global env for each processes
  working_dir APP_ROOT # path below can be relative to this

  process :puma do
    daemonize true
    pid_file APP_PID

    start_timeout 15.seconds
    stop_timeout 10.seconds
    restart_grace 15.seconds

    start_command "#{BUNDLE_PATH} exec puma -C #{PUMA_PATH}"
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
