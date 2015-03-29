require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LolboxSrv
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('lib/assets')
    config.autoload_paths += %W(#{Rails.root.join('app/validators')})

    # Cache
    config.cache_store = :redis_store, "redis://#{ENV['REDIS_HOST']}:6379/0/cache"

    # Generator
    config.generators do |g|
      g.orm :active_record
      g.helper false
      g.helper_specs false
      g.stylesheets false
      g.javascripts false
    end

    # Versioncake
    config.versioncake.version_key = "api_version"
    config.versioncake.supported_version_numbers = (1...4)
    config.versioncake.default_version = 1
    config.versioncake.extraction_strategy = [:query_parameter, :request_parameter, :http_header, :http_accept_parameter]
  end
end
