host, port = YAML.load_file(Rails.root + 'config/resque.yml')[Rails.env].split(":")
REDIS = Redis.new(:host => host, :port => port, :db => 1)
ENV['QUIZ_RESPONDER_REDIS'] ||= "#{host}:#{port}/0"
if Rails.env.production?
  ENV['REDIS_CACHE_STORE'] ||= "redis://#{host}:#{port}/0/cache"
else
  ENV['REDIS_CACHE_STORE'] ||= "redis://localhost:6379/0/cache"
end

