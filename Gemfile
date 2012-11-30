source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'rake', '0.9.2'

gem 'mysql2'
gem 'jquery-rails', '~> 1.0.14'
gem 'devise', '~> 1.5.3'
gem 'omniauth', '= 1.0.3'
gem 'omniauth-facebook'
gem 'oa-oauth', '~> 0.3.0', :require => 'omniauth/oauth'
gem 'therubyracer', '~> 0.9.4'
gem 'resque', '~> 1.20.0'
gem 'resque_mailer', '~> 2.0.2'
gem 'resque-scheduler', '~>2.0.0', :require => 'resque_scheduler'
gem 'brcpfcnpj', '= 3.0.4'
gem 'hpricot'
gem 'fastercsv'
gem 'glennfu-contacts', '= 1.2.6', :path => "vendor/gems", :require => "contacts"
gem 'cancan', '~> 1.6.7'
gem 'enumerate_it'
gem 'fog', '~> 1.1.1'
gem 'carrierwave', '~> 0.6.0'
gem 'mini_magick', '= 3.3'
gem 'zipruby'
gem 'will_paginate'
gem 'airbrake'
gem 'haml'
gem 'haml-rails'

group :production, :staging do
  gem 'asset_sync', '~> 0.5.0'
  gem 'yui-compressor'
end

gem 'moip', :git => 'git://github.com/olook/moip-ruby.git', :branch => 'master'
gem 'obraspag', '>= 0.0.21', :git => 'git@github.com:olook/obraspag.git', :branch => 'master'
gem 'curb'
gem 'state_machine', '~> 1.1.0'
gem 'state_machine-audit_trail', '~> 0.0.5'
gem 'savon', '= 0.9.9'
gem 'httpi', '= 0.9.7'
gem 'paper_trail', '~> 2'
gem 'meta_search'
gem 'newrelic_rpm'
# gem 'graylog2_exceptions'
gem 'SyslogLogger', :require => 'syslog_logger'
gem 'koala', '~> 1.3.0'
gem 'dalli', '2.0.2'

gem 'sass-rails', "~> 3.2.3"
gem 'uglifier', '~> 1.0.3'
gem 'business_time'

gem "rails-settings-cached"
gem "celluloid"


group :development do
  gem 'faker'
  gem 'bullet'
  gem 'thin'
end

group :development, :test do
  gem 'sqlite3'
  gem 'capistrano'
  gem 'factory_girl_rails', '~> 3.2.0'
  gem 'rspec-rails', '~> 2.10.1'
  gem 'watchr'
  gem 'awesome_print'
  gem 'rails-erd'
  if RUBY_VERSION <= "1.9.2"
    gem "ruby-debug19", :require => "ruby-debug", :platform => :ruby_19
  end
  gem "pry"
  gem 'delorean'
end

group :test do
  gem "equivalent-xml", " ~> 0.2.9"
  gem 'capybara', '~> 1.1.1'
  gem "capybara-webkit", "~> 0.13.0"
  gem 'database_cleaner'
  gem 'rspec', '~> 2.10.0'
  gem 'shoulda-matchers'
  gem 'simplecov', '~> 0.5.3', :require => false
  gem 'spork', '~> 0.9.1'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'launchy'
  gem 'vcr', '1.11.3'
  #gem 'webmock', '1.7.0'
  gem 'fakeweb'
  gem 'selenium-webdriver', '2.21.1'
  #gem 'webmock-disabler'
end

group :production do
  gem 'unicorn', '~> 4.1.1'
end
