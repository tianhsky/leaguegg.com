DynamicSitemaps.configure do |config|
  config.path = Rails.root.join("public")
  config.folder = "pub_sitemaps" # This folder is emptied on each sitemap generation
  config.index_file_name = "index.xml"
  config.always_generate_index = false # Makes sitemap.xml contain the sitemap
  config.config_path = Rails.root.join("config", "sitemap.rb")
  config.per_page = 5000
end