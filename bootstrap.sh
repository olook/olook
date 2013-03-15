#!/bin/bash

bundle install

echo "Copying gsg keys for deploy and servers access"
[[ ! -a ~/.ec2 ]] && mkdir ~/.ec2
cp ./config/deploy/gsg-keypair* ~/.ec2/
chmod 0600 ~/.ec2/gsg-keypair*

for f in config/deploy/*.yml.erb; do
  dest="config/$(echo $f | sed 's/.*\/\(.*\).erb/\1/')"
  cat $f | sed 's/<%= "#{application}_\([^"]*\)" %>/olook_\1/' | sed 's/<%.*%>//' > $dest
  echo "$f -> $dest"
done

bundle exec rake db:create db:migrate olook:seed_admin db:seed olook:create_permissions
bundle exec rake db:create db:migrate olook:seed_admin db:seed olook:create_permissions RAILS_ENV=test
