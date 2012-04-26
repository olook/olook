# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rack/cache'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Olook
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{Rails.root}/app/presenters #{Rails.root}/app/services #{Rails.root}/app/adapters #{Rails.root}/app/workers #{Rails.root}/app/validators #{Rails.root}/app/models/ecommerce #{Rails.root}/lib #{Rails.root}/app/strategies/**/ )
    config.autoload_paths += Dir["#{Rails.root}/lib/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    config.active_record.observers = :user_observer, :invite_observer, :order_observer, :used_coupon_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'pt-BR'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation, :credit_card_number, :security_code, :expiration_date, :user_identification, :telephone]

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.action_mailer.default_url_options = { :host => 'www.olook.com.br' }

    config.middleware.use "Graylog2Exceptions", { :hostname => '107.21.158.126', :port => '12201', :level => 0 }


  end
end
