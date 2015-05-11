namespace :bower do
  task :install do
    on roles([:web]) do
      within release_path do
        execute :rake, 'bower:install CI=true'
      end
    end
  end
end