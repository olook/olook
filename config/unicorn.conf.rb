# -*- encoding : utf-8 -*-
# Unicorn configuration file

listen "/tmp/sockets/unicorn.sock", :backlog => 64
worker_processes 4
pid "/var/run/olook-unicorn.pid"
stderr_path "/var/log/olook-unicorn-error.log"
stdout_path "/var/log/olook-unicorn.log"
