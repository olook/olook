# -*- encoding : utf-8 -*-
CRITEO_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/criteo.yml")[Rails.env]
