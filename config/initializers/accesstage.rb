# -*- encoding : utf-8 -*-
ACCESSTAGE_CONFIG = YAML.load_file("#{Rails.root}/config/accesstage.yml")[Rails.env]

Accesstage.setup do |config|
  config.environment = ACCESSTAGE_CONFIG["environment"]
  config.integration_id = ACCESSTAGE_CONFIG["IntegrationId"]
  config.customer_id = ACCESSTAGE_CONFIG["CustomerId"]
  config.affiliation_id = ACCESSTAGE_CONFIG["AffiliationId"]
  config.affiliation_password = ACCESSTAGE_CONFIG["AffiliationPassword"]
  config.username = ACCESSTAGE_CONFIG["username"]  
  config.password = ACCESSTAGE_CONFIG["password"]
end
