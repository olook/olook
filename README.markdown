Requirements
============

- Ruby 1.9.2p290
- Redis 2.4.2 (brew install redis (OS X only))
- MySQL 5.1.49 on Ubuntu 11.04
- libmysqlclient-dev
- libcurl3-gnutls
- ImageMagick
- Memcached 1.4.5

Setup
============

- bundle install
- copy config/database.yml.sample to config/database.yml
- copy config/facebook.yml.sample to config/facebook.yml and set your app_id and app_secret.
- copy config/yahoo.yml.sample to config/yahoo.yml and set your api_key, api_secret and callback_uri.
- copy config/aws.yml.sample to config/aws.yml and set your aws_account, aws_secret and cdn distribution id.
- copy config/analytics.yml.sample to config/analytics.yml and set your analytics_id.
- copy config/email.yml.sample to config/email.yml and set your email account.
- copy config/moip.yml.sample to config/moip.yml and set your uri, token and key.
- copy config/resque.yml.sample to config/resque.yml and set the redis server routes.
- copy config/abacos.yml.sample to config/abacos.yml
- rake db:create && rake db:create RAILS_ENV=test
- rake db:migrate && rake db:migrate RAILS_ENV=test
- rake olook:seed_admin RAILS_ENV=test
- rake db:seed
- rake olook:create_permissions RAILS_ENV=test

Running the application
============

- To start Redis and one worker that can process jobs from all queues:
  - redis-server
  - QUEUE=* bundle exec rake environment resque:work RAILS_ENV=development

- To start a queue for the delayed/scheduled jobs:
  - bundle exec rake environment resque:scheduler
  - rails server

Running tests
============

- rake db:migrate RAILS_ENV=test
- rspec spec
- If tests break on Linux due to issues with Database Cleaner, tweak my.cnf increasing the size of max_allowed_packet should fix them.

Installing MySQL 5.1.49 on Ubuntu/Debian
============

- sudo apt-get install mysql-server-5.1

Deploy with Capistrano
============

-Deploy Development
-Default branch set to development
cap --set-before branch=YOUR_BRNCH_NAME dev deploy

Cronjobs
============
This cron will generate a csv file with the user data to be used for email marketing. It will run everyday at 3 AM.

0  3    * * *   root    cd /srv/olook/current; RAILS_ENV=production bundle exec rake marketing_uploader:copy_userbase_to_ftp >> /var/log/userbase_uploader_rake.log 2>&1

This cron will generate a csv file with the user data, credits and orders data. It will run everyday at 1 AM.

0  1    * * *   root    cd cd /srv/olook/current; RAILS_ENV=production bundle exec rake marketing_uploader:copy_userbase_orders_to_ftp >> /var/log/userbase_orders_uploader_rake.log 2>&1

This cron will generate a csv file with the user data, bonus credits and revenues per user (with users with an accepted order) It will run everyday at 2 AM.

0  2    * * *   root    cd cd /srv/olook/current; RAILS_ENV=production bundle exec rake marketing_uploader:copy_userbase_revenue_to_ftp >> /var/log/userbase_revenue_uploader_rake.log 2>&1

0  0    * * 1   root    cd cd /srv/olook/current; RAILS_ENV=production bundle exec rake marketing_uploader:copy_paid_marketing_revenue_to_ftp >> /var/log/paid_online_marketing_uploader_rake.log 2>&1

Check the log files to verify if any issue happens.

Deployment with Capistrano
============

development:
cap dev deploy

homolog:
cap hmg deploy

production app1:
cap prod1 deploy

production app2:
cap prod2 deploy

If you need to deploy a different branch:
cap --set-before branch=<your_branch_name> dev deploy

Optional config files
============
- .rvmrc
  - run the following command inside the project directory
  ```
  rvm --rvmrc --create 1.9.2@olook
  ```

- .rspec
  - create a file named .rspec inside the project directory with the following content:
  ```
  --color
  --format documentation
  --drb
  ```
  The parameter color will color the output, format 'documentation' shows the tests description instead of dots and
  drb will try to use spork if available.
