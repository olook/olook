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

Make sure mysql is running before you run this:

run ./bootstrap.sh

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

Installing MySQL 5.5.28 on mac os 10.7
============

Download the package dmg and install
- http://dev.mysql.com/downloads/mirror.php?id=409829

Installing capybara-webkit on Ubuntu
============
- sudo apt-get install qt4-dev-tools libqt4-dev libqt4-core libqt4-gui
- bundle

Installing capybara-webkit on a Mac
============
- brew install qt
- bundle

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
cap -S branch=<your_branch_name> SERVER deploy

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

- .git/hooks/pre-commit
  - create a file named .git/hooks/pre-commit inside project directory with the following content:
  - after creating it, execute the command 'chmod +x .git/hooks/pre-commit'

```
#!/bin/bash
## START PRECOMMIT HOOK
  
files_modified=`git status --porcelain | egrep "^(A |M |R ).*" | awk ' { if ($3 == "->") print $4; else print $2 } '`
  
for f in $files_modified; do
    echo "Checking ${f}..."

    if [[ $f == *.rb ]]; then
        if grep --color -n "binding.pry" $f; then
            echo "File ${f} failed - found 'binding.pry'"
            exit 1
        fi

        if grep --color -n "debugger" $f; then
            echo "File ${f} failed - found 'debugger'"
            exit 1
        fi

        if grep --color -n "save_and_open_page" $f; then
            echo "File ${f} failed - found 'save_and_open_page'"
            exit 1
        fi
    fi
done
exit
## END PRECOMMIT HOOK
```
