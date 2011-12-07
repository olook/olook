require "resque"
require "resque_scheduler"
require "resque/failure/multiple"
require "resque/failure/airbrake"
require "resque/failure/redis"

Resque.redis = YAML.load_file(Rails.root + 'config/resque.yml')[Rails.env]

Resque::Failure::Airbrake.configure do |config|
  config.api_key = '7d489c216b28c67d36d16be815ae48b1'
  config.secure = true
end

Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
Resque::Failure.backend = Resque::Failure::Multiple
