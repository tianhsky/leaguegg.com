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

set :assets_roles, [:web]

namespace :deploy do

  before 'updated', 'bundle:install'
  # before 'deploy:compile_assets', 'bower:install'
  after 'published', 'service:restart_puma'

end
