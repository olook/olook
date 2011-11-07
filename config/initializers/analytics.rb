# -*- encoding : utf-8 -*-
ANALYTICS_CONFIG = YAML.load_file("#{Rails.root}/config/analytics.yml")[Rails.env]
