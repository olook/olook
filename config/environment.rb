# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

require './lib/oauth_import'

# Initialize the rails application
Olook::Application.initialize!
