Requirements
============

- Ruby 1.9.2 or higher
- PostgreSQL 9.1

Setup
============

- bundle install
- copy config/database.yml.sample to config/database.yml
- rake db:create && rake db:create RAILS_ENV=test
- rake db:migrate && rake db:migrate RAILS_ENV=test
- rake spec
- rake db:seed

Installing Postgres 9.1 on Ubuntu/Debian
============
*References: https://help.ubuntu.com/community/PostgreSQL*

- sudo add-apt-repository ppa:pitti/postgresql
- sudo apt-get update
- sudo apt-get install postgresql-9.1
- sudo -u postgres psql postgres

Type the following commands:

```
\password postgres
Enter the new password, it's recommended to use "postgres"
CTRL+D
```

To install an admin with GUI:

- sudo apt-get install pgadmin3

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
