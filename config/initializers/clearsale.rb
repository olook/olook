CLEARSALE_CONFIG = YAML.load_file("#{Rails.root}/config/clearsale.yml")[Rails.env]
ENV["CLEARSALE_ENV"] = CLEARSALE_CONFIG[Rails.env]["environment"]
ENV["CLEARSALE_ENTITYCODE"] = CLEARSALE_CONFIG[Rails.env]["entity_code"]
