# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'lolcaf'
set :repo_url, 'git@bitbucket.org:tianhsky/lolcaf-srv.git'
set :scm, :git
set :format, :pretty
set :log_level, :info
set :keep_releases, 10
set :linked_dirs, %w{log tmp}

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

namespace :deploy do

  after :publishing, :bundle_install do
    on release_roles :all, in: :parallel do
      within release_path do
        execute :bundle, 'install'
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
