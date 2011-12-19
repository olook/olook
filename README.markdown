Requirements
============

- Ruby 1.9.2 or higher
- Redis 2.4.2 (brew install redis (OS X only))
- MySQL 5.1.49 on Ubuntu 11.04

Setup
============

- bundle install
- copy config/database.yml.sample to config/database.yml
- copy config/facebook.yml.sample to config/facebook.yml and set your app_id and app_secret.
- copy config/yahoo.yml.sample to config/yahoo.yml and set your api_key, api_secret and callback_uri.
- copy config/aws.yml.sample to config/aws.yml and set your aws_account, aws_secret and cdn distribution id.
- copy config/analytics.yml.sample to config/analytics.yml and set your analytics_id.
- copy config/email.yml.sample to config/email.yml and set your email account.
- rake db:create && rake db:create RAILS_ENV=test
- rake db:migrate && rake db:migrate RAILS_ENV=test
- rake db:seed

Running the application
============

- redis-server
- QUEUE=* bundle exec rake environment resque:work
- bundle exec rake environment resque:scheduler (this will start a queue for the delayed/scheduled jobs)
- rails server

Running tests
============

- rspec spec

Installing MySQL 5.1.49 on Ubuntu/Debian
============

- sudo apt-get install mysql-server-5.1

Optional config files
============
- .rvmrc
  - run the following command inside the project directory
  ```
  rvm --rvmrc --create 1.9.2@olook
  ```

- .rspec
  - create a file named .rspec inside the project directory with the following content
  ```
  --color
  --format documentation
  ```
