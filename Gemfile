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


group :development, :test do
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

