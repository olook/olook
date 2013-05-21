require 'resque/pool/tasks'

task "resque:pool:setup" => :environment do
  # close any sockets or files in pool manager
  ActiveRecord::Base.connection.disconnect!

  # and re-open them in the resque worker parent
  Resque::Pool.after_prefork do |job|
    ActiveRecord::Base.establish_connection
    Resque.redis = YAML.load_file(Rails.root.join('config', 'resque.yml'))[Rails.env]

    NewRelic::Agent.after_fork(:force_reconnect => true) if defined?(NewRelic)

    Resque::Failure::Airbrake.configure do |config|
      config.api_key = '7d489c216b28c67d36d16be815ae48b1'
      config.secure = true
    end

    Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
    Resque::Failure.backend = Resque::Failure::Multiple
  end
end
