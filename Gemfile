source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'mysql'
gem 'jquery-rails', '~> 1.0.14'

group :development, :test do
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
