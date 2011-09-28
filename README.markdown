Requirements
============

- Ruby 1.9.2 or higher

Setup
============

- bundle install
- copy config/database.yml.sample to config/database.yml
- copy config/facebook.yml.sample to config/facebook.yml and set your app_id and app_secret
- rake db:create && rake db:create RAILS_ENV=test
- rake db:migrate && rake db:migrate RAILS_ENV=test
- rake spec
- rake db:seed