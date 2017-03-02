namespace :redis do
  namespace :cache do
    task :clear => :environment do
      desc "Clear cache"
      Rails.cache.clear
    end
  end
end