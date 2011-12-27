# -*- encoding: utf-8 -*-
moip_config_path = File.dirname(__FILE__) + '/../../config/moip.yml'
MOIP_CONFIG = YAML.load_file(moip_config_path)[Rails.env]

MoIP.setup do |config|
  config.uri   = MOIP_CONFIG['uri']
  config.token = MOIP_CONFIG['token']
  config.key   = MOIP_CONFIG['key']
end
