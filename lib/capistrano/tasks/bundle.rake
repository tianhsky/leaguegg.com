namespace :bundle do
  task :install do
    on roles([:web]), in: :parallel do
      within release_path do
        execute :gem, 'install bundle'
        execute :bundle, 'install'
      end
    end
  end
end