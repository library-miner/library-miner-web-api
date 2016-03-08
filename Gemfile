source 'https://rubygems.org'

gem 'rails', '>= 5.0.0.beta2', '< 5.1'
gem 'mysql2', '0.3.19'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# Action Cable dependencies for the Redis adapter
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'active_hash'
gem 'convergence'
gem 'rubocop'
gem 'faraday'
gem 'rails-i18n'
gem 'active_model_serializers'
gem 'kaminari'

# 環境設定
gem 'dotenv-rails'
# クロスドメイン
gem 'rack-cors', require: 'rack/cors'

group :development, :test do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end

group :development do
  gem 'spring'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.2.0', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-rails', require: false
  gem 'rvm1-capistrano3', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-maintenance', github: 'capistrano/maintenance', require: false
end

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'webmock'
end
