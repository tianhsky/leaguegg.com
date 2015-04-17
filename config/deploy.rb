# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'lolcaf'
set :repo_url, 'git@bitbucket.org:tianhsky/lolcaf-srv.git'
set :scm, :git
set :format, :pretty
set :log_level, :info
set :keep_releases, 10
set :linked_dirs, %w{log tmp}

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
