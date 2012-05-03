# -*- encoding : utf-8 -*-
# Unicorn configuration file

listen "/tmp/unicorn.sock", :backlog => 64
worker_processes 15
pid "/var/run/olook-unicorn.pid"
stderr_path "/mnt/olook-unicorn-error.log"
stdout_path "/mnt/olook-unicorn.log"
preload_app true


after_fork do |server, worker|
 Rails.cache.reset if Rails.cache.respond_to?(:reset)
end
