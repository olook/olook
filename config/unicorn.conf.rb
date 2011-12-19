# -*- encoding : utf-8 -*-
# Unicorn configuration file

listen "/tmp/unicorn.sock", :backlog => 64
worker_processes 4
pid "/var/run/olook-unicorn.pid"
stderr_path "/mnt/olook-unicorn-error.log"
stdout_path "/mnt/olook-unicorn.log"
