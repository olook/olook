require "resque"
require "resque/failure/multiple"
require "resque/failure/airbrake"
require "resque/failure/redis"

Resque.redis = YAML.load_file(Rails.root + 'config/resque.yml')[Rails.env]

Resque::Failure::Airbrake.configure do |config|
  config.api_key = 'ea4592991b87980de4f0edfb2a5a78be'
end

Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
Resque::Failure.backend = Resque::Failure::Multiple
