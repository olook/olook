require 'resque/pool/tasks'

task "resque:pool:setup" => :environment do
  # close any sockets or files in pool manager
  ActiveRecord::Base.connection.disconnect!

  # and re-open them in the resque worker parent
  Resque::Pool.after_prefork do |job|
    ActiveRecord::Base.establish_connection
    Resque.redis.client.reconnect
  end
end
