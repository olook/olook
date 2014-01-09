source 'http://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'rake', '0.9.2'

gem 'mysql2'
gem 'aws-sdk', '~> 1.0'
gem 'jquery-rails', '~> 1.0.14'
gem 'devise', '~> 1.5.3'
gem 'omniauth', '= 1.0.3'
gem 'omniauth-facebook'
gem 'oa-oauth', '~> 0.3.0', :require => 'omniauth/oauth'
gem 'therubyracer', '~> 0.12.0'
gem 'resque', '~> 1.20.0', :require => 'resque/server'
gem 'resque_mailer', '~> 2.0.2'
gem 'resque-scheduler', '~>2.0.0', :require => ['resque_scheduler', 'resque_scheduler/server']
gem 'resque-pool'
gem 'puma', require: false #for resque web in rubber
gem 'brcpfcnpj', '= 3.0.4'
gem 'hpricot'
gem 'fastercsv'
gem 'glennfu-contacts', '= 1.2.6', :path => "vendor/gems", :require => "contacts"
gem 'cancan', '~> 1.6.7'
gem 'enumerate_it', '~> 0.7.14'
gem 'fog', '~> 1.2'
gem 'carrierwave', '~> 0.6.0'
gem 'mini_magick', '= 3.3'
gem 'zipruby'
gem 'will_paginate'
gem 'airbrake', '~> 3.1.6'
gem 'haml'
gem 'haml-rails'
gem 'i18n', '= 0.6.1'
gem 'clearsale', :git => 'git://github.com/olook/clearsale.git', :branch => 'master'
gem 'acts_as_list'
gem 'chaordic-packr', "4.0.0", git: 'git@github.com:olook/chaordic-packr.git', branch: 'master'
gem 'oj'
gem 'moip', '>= 1.0.2.3', :git => 'git://github.com/olook/moip-ruby.git', :branch => 'master'
gem 'obraspag', '>= 0.0.31', :git => 'git@github.com:olook/obraspag.git', :branch => 'master'
gem 'curb'
gem 'state_machine', '~> 1.1.0'
gem 'state_machine-audit_trail', '~> 0.0.5'
gem 'savon', '= 0.9.9'
gem 'gyoku', '= 0.4.6'
gem 'httpi', '= 0.9.7'
gem 'paper_trail', '~> 2'
gem 'meta_search'
gem 'newrelic_rpm'
# gem 'graylog2_exceptions'
gem 'SyslogLogger', "~> 1.4.1"
gem 'koala', '~> 1.3.0'
gem 'dalli', '2.0.2'
gem 'redis-rails'
gem 'sitemap_generator'

gem 'sass-rails', "~> 3.2.3"
gem 'uglifier', '~> 1.0.3'
gem 'business_time'
gem "rails-settings-cached"

gem "boleto_bancario", :git => 'git@github.com:olook/boleto_bancario.git', :branch => 'homologacao_santander', require: false
gem 'fb-channel-file'

group :production, :staging do
  gem 'unicorn', '~> 4.1.1'
  gem 'asset_sync', '~> 0.5.0'
  gem 'yui-compressor'
end

gem 'piet', :git => 'git://github.com/albertbellonch/piet.git', ref: "630a98bef1595fb2a138e98ff9aaefbca987a999"

group :development, :test do
  gem 'better_errors'
  gem 'faker'
  gem 'bullet'
  gem 'thin'
  gem 'rb-inotify', '~> 0.9', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'sqlite3', '~> 1.3.6'
  gem 'capistrano'
  gem 'capistrano-maintenance'
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'rspec-rails', '~> 2.12.0'
  gem 'watchr'
  gem 'awesome_print'
  gem 'rails-erd'
  gem "pry"
  gem "pry-nav"
  gem 'delorean'
  gem 'timecop'
  gem 'shoulda-matchers'
  gem 'poltergeist'
  gem "equivalent-xml", " ~> 0.2.9"
  gem 'capybara', '2.0.2'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'spork', '~> 0.9.2'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'fuubar'
  gem "vcr", "~> 2.5.0"
  gem 'ci_reporter', :git => 'git://github.com/nicksieger/ci_reporter.git', require: false
 # gem 'jasmine'
  gem 'binding_of_caller'
  gem 'rack-mini-profiler', '~> 0.1.23'
end
gem 'rubber', '~> 2.0', git: 'git://github.com/nelsonmhjr/rubber.git', branch: 'newrelic'
gem 'open4'

gem "codeclimate-test-reporter", group: :test, require: nil
group :test do
  gem 'webmock'
end
