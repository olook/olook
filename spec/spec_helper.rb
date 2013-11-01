# -*- encoding : utf-8 -*-
require 'rubygems'
require 'spork'
require "codeclimate-test-reporter"
#CODECLIMATE_REPO_TOKEN=f8b9bc0159baef99717bde98ff461e5ecd83f2fb4ce41df305e38709f99aceac
CodeClimate::TestReporter.start

# Formatter for simplecov, to work with jenkins
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails' if ENV["COVERAGE"]

module Resque
  def self.enqueue(*args); end
  def self.enqueue_in(*args); end
  def self.enqueue_at(*args); end
end


Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  if ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start 'rails' do
      add_group "Long files" do |src_file|
        src_file.lines.count > 100
      end
      add_filter "/vendor/"
    end
  end

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
end

Spork.each_run do
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'carrierwave/test/matchers'
  require 'capybara/poltergeist'
  require 'webmock/rspec'
  include ActionView::Helpers::NumberHelper

  # Since we're using devise, the spork guys recommend us to reload the routes on this step
  # https://github.com/timcharper/spork/wiki/Spork.trap_method-Jujutsu
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!) if defined?(Rails)

  Capybara.javascript_driver = :poltergeist

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = {
    'provider' => 'facebook',
    'extra' => {"raw_info" => {"email" => "user@mail.com", "first_name" => "User Name", "last_name" => "Last Name", "id" => "abc"}},
    'credentials' => {'token' => "AXDV"}
  }

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Savon.configure do |config|

    # By default, Savon logs each SOAP request and response to $stdout.
    # Here's how you can disable logging:
    config.log = false

  end

  HTTPI.log = false
  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true

    # Trying: http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
    # And https://gist.github.com/855604
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:each) do
      Delorean.back_to_the_present
    end

    config.mock_with :rspec

    # Used by Image Uploader fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    def (ActionDispatch::Integration::Session).fixture_path
      config.fixture_path
    end

    config.include ActionDispatch::TestProcess
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    config.include Devise::TestHelpers, :type => :controller
  end
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  FactoryGirl.reload

  RSpec.configure do |config|
    config.include Abacos::TestHelpers
  end

  #Requires libs. Check why I need to do it later
  Dir[Rails.root.join("lib/**/*.rb")].each {|f| require f}

end
