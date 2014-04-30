# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

require './lib/oauth_import'
require './lib/cloudfront_invalidator'

# Initialize the rails application
Olook::Application.initialize!

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # We're in smart spawning mode.
    if forked
      # Re-establish redis connection
      REDIS.client.reconnect
      Resque.redis.client.reconnect
      Rails.cache.reconnect
    end
  end
end
