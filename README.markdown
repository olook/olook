Requirements
============

- Ruby 1.9.2 or higher

  bundle install

- copy config/database.yml.sample to config/database.yml

  rake db:create && rake db:create RAILS_ENV=test
  rake db:migrate && rake db:migrate RAILS_ENV=test
  rake spec