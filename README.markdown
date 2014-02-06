[![Build Status](https://jenkins.olook.com.br:8080/job/olook/badge/icon)](https://jenkins.olook.com.br:8080/job/olook/)


Requirements
============

- Ruby 2.0.0 p195
- Redis 2.4.2 (brew install redis (OS X only))
- MySQL 5.1.49 on Ubuntu 11.04
- libqt4-dev
- libmysqlclient-dev
- libcurl3-gnutls
- ImageMagick
- Memcached 1.4.5
- PhantomJS (New)

Setup
============

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

Installing MemCached on Ubuntu
============
- sudo apt-get install memcached
- bundle

Installing capybara-webkit on a Mac
============
- brew install qt
- bundle

Installing MemCached on a Mac via HomeBrew
============
- brew install memcached
- bundle

How connect to Homolog
============
- ssh -i ~/.ec2/gsg-keypair root@homolog.olook.com.br -A


How connect to Resque 01
============
- ssh -i ~/.ec2/gsg-keypair root@resque01.olook.com.br -A

Deploy with Capistrano
============

Set ssh-agent
```
ssh-add
```

check if ssh-agent is running. It should be running since most OSes start them on ssh connection.

```
ssh-agent
```

Run to config keys in your machine
```
bash bootstrap.sh development
```

-Deploy staging env ALL hosts
-Default branch set to master
```
cap deploy
```

development:
```
cap deploy FILTER=development
```

homolog:
```
cap deploy FILTER=homolog
```

homolog specific branch:
```
cap -S branch=YOUR_BRANCH deploy FILTER=homolog
```

production app01:
```
RUBBER_ENV=production FILTER=app01 cap deploy
```

production app02:
```
RAILS_ENV=production FILTER=app02 cap deploy
```

production only resques:
```
RUBBER_ENV=production ROLES=resque cap deploy
```

Deploy with migrations:
```
RUBBER_ENV=production cap deploy:migrations
```

If you need to deploy a different branch:
```
cap -S branch=<your_branch_name> deploy
```

Optional config files
============
- .rvmrc
  - run the following command inside the project directory
  ```
  rvm --rvmrc --create 1.9.3@olook
  ```

- .rspec
  - create a file named .rspec inside the project directory with the following content:
  ```
  --color
  --format Fuubar
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

    if [[ $f == *.rb || $f == *.haml || $f == *.erb ]]; then
        if grep --color -n "binding.pry" $f; then
            echo "File ${f} failed - found 'binding.pry'"
            exit 1
        fi

        if grep --color -n "debugger" $f; then
            echo "File ${f} failed - found 'debugger'"
            exit 1
        fi
    fi
done
exit
## END PRECOMMIT HOOK
```
