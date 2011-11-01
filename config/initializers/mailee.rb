# -*- encoding : utf-8 -*-
MAILEE_CONFIG = YAML.load_file("#{Rails.root}/config/mailee.yml")[Rails.env]
Mailee::Config.site = MAILEE_CONFIG[:site]
Mailee::Message.format = ActiveResource::Formats::XmlFormat
Mailee::Contact.format = ActiveResource::Formats::XmlFormat
