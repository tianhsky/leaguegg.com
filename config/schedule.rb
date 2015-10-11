set :output, File.join(File.expand_path(File.dirname(__FILE__)), '..', 'log', 'whenever.log')

every 8.minutes do
  rake "games:featured:fetch"
end
