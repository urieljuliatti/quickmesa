# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'

gem 'rails', '~> 7.1.4'

gem 'pg', '~> 1.1'

gem 'puma', '>= 5.0'

gem 'tzinfo-data', platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'shoulda-matchers', '~> 6.0'
end

group :development do
  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
end

gem 'devise'
gem 'devise-jwt'
gem 'jsonapi-serializer'
gem 'rack-cors'
