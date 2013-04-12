host, port = YAML.load_file(Rails.root + 'config/resque.yml')[Rails.env].split(":")
REDIS = Redis.new(:host => host, :port => port)
