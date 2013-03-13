#!/bin/bash

bundle install

[[ ! -a ~/.ec2 ]] && mkdir ~/.ec2
cp ./config/deploy/gsg-keypair* ~/.ec2/
chmod 0600 ~/.ec2/gsg-keypair*

ruby <<SCRIPT
require 'erb'
  Dir["./config/deploy/*.yml.erb"].each do |location|
    template = File.read(location)
    /.*\/(?<file>.*)\.erb/ =~ location.to_s

    config = ERB.new(template)

    application = 'olook'
    File.open('./config/database.yml', 'w') do |f|
      f.puts config.result(binding)
    end

  end
SCRIPT

bundle exec rake db:create db:migrate olook:seed_admin db:seed olook:create_permissions
bundle exec rake db:create db:migrate olook:seed_admin db:seed olook:create_permissions RAILS_ENV=test
