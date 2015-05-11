namespace :service do
  task :restart_puma do
    on roles([:web]), in: :groups, limit: 3, wait: 10 do
      within shared_path do
        execute :eye, "load eye/app*.rb"
        execute :eye, "restart lolcaf_app"
        sleep 20
        execute :eye, "restart lolcaf_app2"
      end
    end
  end
end