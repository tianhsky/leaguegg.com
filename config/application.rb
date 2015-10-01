require File.expand_path('../boot', __FILE__)

# require 'rails/all'
require "action_controller/railtie"
require "action_mailer/railtie"
require "thread"
Bundler.require(*Rails.groups)

module LolboxSrv
  class Application < Rails::Application
    config.eager_load_paths += %W(#{Rails.root.join('lib')})
    # config.assets.paths << Rails.root.join('lib/assets')

    # Cache
    config.cache_store = :redis_store, ENV['REDIS_CACHE_URL']

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
