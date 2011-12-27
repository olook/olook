# -*- encoding: utf-8 -*-
moip_config_path = File.dirname(__FILE__) + '/../../config/moip.yml'
moip_config = YAML.load_file(moip_config_path)

(Rails.env == 'production') ? @moip_config = moip_config['production'] : @moip_config = moip_config['development']

MoIP.setup do |config|
  config.uri   = @moip_config['uri'] if true
  config.token = @moip_config['token']
  config.key = @moip_config['key']
end
