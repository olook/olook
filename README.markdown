Requirements
============

- Ruby 1.9.2 or higher
- MySQL 5.1.49 on Ubuntu 11.04

Setup
============

- bundle install
- copy config/database.yml.sample to config/database.yml
- rake db:create && rake db:create RAILS_ENV=test
- rake db:migrate && rake db:migrate RAILS_ENV=test
- rake spec
- rake db:seed

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
