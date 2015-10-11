namespace :games do
  namespace :featured do
    task :fetch => :environment do
      desc "Fetch current featured games"
      ::GameService::Service.store_current_featured_games
    end
  end
end