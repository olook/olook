host, port = YAML.load_file(Rails.root + 'config/resque.yml')[Rails.env].split(":")
REDIS = Redis.new(:host => host, :port => port, :db => 1)
ENV['QUIZ_RESPONDER_REDIS'] ||= "#{host}:#{port}/0"
