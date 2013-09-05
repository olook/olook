# -*- encoding: utf-8 -*-
moip_config_path = File.dirname(__FILE__) + '/../../config/moip.yml'
MOIP_CONFIG = YAML.load_file(moip_config_path)[Rails.env] rescue nil

if MOIP_CONFIG.nil?
  Rails.logger.warn("MOIP config not found make sure that it's present when you get your system up or it will not work for moip related payments")
else
  MoIP.setup do |config|
    config.uri   = MOIP_CONFIG['uri']
    config.token = MOIP_CONFIG['token']
    config.key   = MOIP_CONFIG['key']
  end
end
