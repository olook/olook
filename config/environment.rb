# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

require './lib/oauth_import'
require './lib/cloudfront_invalidator'

# Initialize the rails application
Olook::Application.initialize!
