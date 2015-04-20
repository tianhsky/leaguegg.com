namespace :twitch do
  namespace :users do
    task :import => :environment do
      desc "Import twitch user csv"
      File.open("tmp/twitch_users.csv", "r") do |f|
        csv_file = f
        updated = 0
        CSV.new(csv_file, {:headers  => true, :header_converters => :symbol}).each do |row|
          puts "#{row}"
          summoner_name = row[:summoner_name]
          region = row[:region]
          twitch_channel = row[:twitch_channel]
          summoner = Summoner::Service.find_summoner_by_summoner_name(summoner_name, region)
          if summoner
            summoner.twitch_channel = twitch_channel
            summoner.save
            puts "updated: #{updated}, #{summoner_name} -> #{twitch_channel}"
            updated += 1
          end
        end
      end
    end
  end
end