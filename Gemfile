source 'https://rubygems.org'

# Env
gem 'dotenv-rails'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
# Use mysql as the database for Active Record
gem 'mysql2'
# User mongoid as documented store
gem 'mongoid', '~> 4.0.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
# Use unicorn as the app server
gem 'unicorn'
# Use Capistrano for deployment
gem 'capistrano-rails', group: :development
# Project version
gem 'semver'
# Api version management
gem 'versioncake'
# Error tracking
gem 'airbrake'
# Annotate model
gem 'annotate'
# Http
gem 'httparty'
# Cache
gem 'redis-rails'
# Print object nicely
gem 'awesome_print', :require => 'ap'
group :development do
	# Debug tools
	gem 'better_errors'
	gem 'binding_of_caller' # together with better_errors enables instance variable inspection
end
group :development, :test do
	# Test suite
	gem 'rspec-rails', '~> 3.0.0'
	gem 'database_cleaner'
	gem 'factory_girl_rails'
end