Split.redis = ENV['REDIS_CACHE_STORE']

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'olook123abc'
end