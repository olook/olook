if defined?(Search)
  Search.config.load_config("#{Rails.root}/config/cloud_search.yml", Rails.env)
end
