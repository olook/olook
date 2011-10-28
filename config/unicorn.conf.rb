# -*- encoding : utf-8 -*-
# Unicorn configuration file

listen 80
worker_processes 2
pid "/var/run/olook-unicorn.pid"
stderr_path "/var/log/olook-unicorn-error.log"
stdout_path "/var/log/olook-unicorn.log"
