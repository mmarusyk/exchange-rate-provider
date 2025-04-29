source 'https://rubygems.org'

gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.2'

gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'thruster', require: false

gem 'blueprinter'
gem 'dry-struct'
gem 'dry-validation'
gem 'faraday'
gem 'oj'
gem 'redis'
gem 'trailblazer'
gem 'trailblazer-rails'

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
end

group :test do
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end
