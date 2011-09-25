source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'sqlite3'
gem 'mysql2', '~> 0.3.7'
gem 'jquery-rails', '~> 1.0.14'
gem 'devise', '~> 1.4.7'
gem 'omniauth', '~> 0.3.0'
gem 'oa-oauth', '~> 0.3.0', :require => 'omniauth/oauth'

group :development, :test do
  gem 'ruby-debug19'
  gem 'capistrano'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'factory_girl_rails', '~> 1.2.0'
  gem 'rspec-rails', '~> 2.6.0'
end

group :test do
  gem 'capybara', '~> 1.1.1'
  gem 'database_cleaner', '~> 0.6.7'
  gem 'rspec', '~> 2.6.0'
  gem 'shoulda', '~> 2.11.3'
  gem 'simplecov', '~> 0.5.3', :require => false
end

group :production do
  gem 'unicorn', '~> 4.1.1'
end	
