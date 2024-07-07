source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "rails", "~> 7.0.8", ">= 7.0.8.4"
gem "sprockets-rails"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "representable"
gem "multi_json"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'net-ssh'
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
gem "puma_worker_killer"

group :development, :test do
  gem "capistrano", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", require: false
  gem "capistrano-rbenv", require: false
  gem 'faker'
  gem "byebug"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "database_cleaner"
  gem "shoulda-matchers"
end

group :development do
  gem "web-console"
end

