# -*- encoding : utf-8 -*-
XML_BLACKLIST = YAML.load_file("#{Rails.root.to_s}/config/criteo.yml")[Rails.env]
