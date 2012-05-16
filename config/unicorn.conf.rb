# -*- encoding : utf-8 -*-
# Unicorn configuration file

listen "/tmp/unicorn.sock", :backlog => 64
worker_processes 15
pid "/var/run/olook-unicorn.pid"
stderr_path "/mnt/olook-unicorn-error.log"
stdout_path "/mnt/olook-unicorn.log"
preload_app true

before_fork do |server, worker| 
  if defined?(ActiveRecord::Base) 
    ActiveRecord::Base.connection.disconnect! 
  end 

  old_pid = '/var/run/olook-unicorn.pid.oldbin' 
  if File.exists?(old_pid) && server.pid != old_pid 
    begin 
      Process.kill("QUIT", File.read(old_pid).to_i) 
    rescue Errno::ENOENT, Errno::ESRCH 
      # someone else did our job for us 
    end 
  end 
end 

after_fork do |server, worker| 
  Rails.cache.reset if Rails.cache.respond_to?(:reset) 
  if defined?(ActiveRecord::Base) 
    ActiveRecord::Base.establish_connection 
  end 
end
