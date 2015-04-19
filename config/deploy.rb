# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'lolcaf'
set :repo_url, 'git@bitbucket.org:tianhsky/lolcaf-srv.git'
set :scm, :git
set :format, :pretty
set :log_level, :info
set :keep_releases, 10
set :linked_dirs, %w{log tmp}
set :linked_files, %w{.env}

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails eye}

set :assets_roles, [:web, :app]

namespace :deploy do

  before :updated, 'bundle:install' do
    on roles(:app), in: :parallel do
      within release_path do
        execute :gem, 'install bundle'
        execute :bundle, 'install'
      end
    end
  end

  after :published, 'app:restart' do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within shared_path do
        execute :eye, 'load eye/app.rb'
        execute :eye, "restart #{fetch(:app_name)}"
      end
    end
  end

end
