#!/bin/bash

bundle install

for filename in config/*.sample 
do
  echo -n "$filename => ";
  file_without_ext=`basename $filename .sample`;
  cp -vn $filename config/$file_without_ext;
done

bundle exec rake db:create db:migrate olook:seed_admin db:seed olook:create_permissions
bundle exec rake db:create db:migrate olook:seed_admin db:seed olook:create_permissions RAILS_ENV=test
