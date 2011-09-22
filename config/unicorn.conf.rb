# Unicorn configuration file

listen /tmp/.olook-unicorn.sock
worker_processes 2
pid "/var/run/olook-unicorn.pid"
stderr_path "/var/log/olook-unicorn-error.log"
stdout_path "/var/log/olook-unicorn.log"
