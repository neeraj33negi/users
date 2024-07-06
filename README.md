# README
* Ruby version - 3.1.2

* System dependencies - mysql-client

* Configuration
  - Ensure mysql and mysql-client is running.
  - clone the repo
  - `bundle install`
  - `cp config/database.yml.erb config/database.yml`
  - add your local db username, password, host in the database.yml
  - `cp config/secrets.yml.erb config/secrets.yml`
  - add api-key(could be any valid random string)

* Database creation
  - `bundle exec rails db:create`

* Database initialization
  - `bundle exec rails db:migrate`
  - `RAILS_ENV=test bundle exec rails db:migrate`


* How to run the test suite
  - `bundle exec rspec`

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

