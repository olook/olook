#!/bin/bash

bundle install

for filename in config/*.sample 
do
	echo $filename;
	file_without_ext=`basename $filename .sample`;#
	echo $file_without_ext;
	mv $filename config/$file_without_ext;
done

git checkout -- .

bundle exec rake db:create && bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:migrate && bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake olook:seed_admin RAILS_ENV=test
bundle exec rake db:seed
bundle exec rake olook:create_permissions RAILS_ENV=test