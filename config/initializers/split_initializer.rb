Split.redis = ENV['REDIS_SPLIT']

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'olook123abc'
end
