set :output, File.join(File.expand_path(File.dirname(__FILE__)), '..', 'log', 'whenever.log')

#every 8.minutes do
#  rake "games:featured:fetch"
#end

every 1.day, :at => '4:30 am' do
  rake "redis:cache:clear"
end

# every 1.day, :at => '0:59 am' do
#   rake "sitemap:generate"
# end

every :tuesday, :at => '2:00 am' do
  rake "summoners:masters:fetch"
end

every :wednesday, :at => '2:00 am' do
  rake "summoners:challengers:fetch"
end

# every :wednesday, :at => '2:00 am' do
#   rake "summoners:all:sync"
# end
