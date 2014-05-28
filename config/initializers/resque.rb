require "resque"
require "resque_scheduler"
require "resque/failure/multiple"
require "resque/failure/airbrake"
require "resque/failure/redis"

Resque.redis = YAML.load_file(Rails.root + 'config/redis.yml')[Rails.env]

Resque::Failure::Airbrake.configure do |config|
  config.api_key = '7d489c216b28c67d36d16be815ae48b1'
  config.secure = true
end

Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
Resque::Failure.backend = Resque::Failure::Multiple

require "resque_scheduler"
require 'resque_scheduler/server'

Resque.schedule = YAML.load_file('config/resque_schedule.yml')

require "resque/server"
Resque::Server.use Rack::Auth::Basic do |user, pass|
  (user == "resque" && pass == "olookresque123abc") || (user == "homolog" && pass == "homolebe")
end

Resque.after_fork do |job|
  Resque.redis.client.reconnect
end
