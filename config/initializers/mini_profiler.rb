Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore

Rack::MiniProfiler.config.user_provider = Proc.new do |env|
  user_id = env['rack.session']['warden.user.user.key'][1][0] rescue nil
  if user_id
    "User[#{ user_id }]"
  else
    Rack::Request.new(env).ip
  end
end

# set RedisStore
if Rails.env.production? || Rails.env.staging?
  uri = URI.parse("redis://" + YAML.load_file(Rails.root + 'config/resque.yml')[Rails.env])
  Rack::MiniProfiler.config.storage_options = { :host => uri.host, :port => uri.port, :password => uri.password }
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
end
