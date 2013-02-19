# load 'deploy/assets'
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano/maintenance'

set :stages, %w(prod1 prod2 prod3 prod4 prodspare prod_prod prod_todas hmg dev resque showroom new_machine apptest)

# app details
set :application, 'olook'
set :path_app, '/srv/olook/current'
set :deploy_to, '/srv/olook'
set :deploy_via, :remote_cache

# server details
set :user, 'root'
set :use_sudo, false
set :version_path, '/srv/olook/current'
set :bundle, '/usr/local/ruby/bin/bundle'
set :rake, '/usr/local/ruby/bin/rake --trace'
set :path_log, '/mnt/debug'

# repo details
set :scm, :git
set :repository, 'git@github.com:olook/olook.git'
set :git_enable_submodules, 1

default_run_options[:pty] = true
ssh_options[:port] = 13630
ssh_options[:forward_agent] = true

trap("INT") {
  print "\n\n"
  exit 42
}

namespace :log do
  desc "Tail all application log files"
  task :tail, :roles => :web do
    run "tail -f #{path_log}" do |channel, stream, data|
      puts "\033[0;33m#{stage}:\033[0m #{data}"
      break if stream == :err
    end
  end
end

namespace :unicorn do
  desc "Shows the pid of unicorn master process"
  task :pidof, :roles => [:app,:web] do
    run "ps fax |grep -v grep |grep 'unicorn_rails master' |awk '{print $1}'" do |x, y, pid|
      puts "\033[0;33m#{stage}:\33[0m \033[0;31m#{pid}\33[0m"
    end
  end

  desc 'Stop unicorn'
  task :stop, :roles => :app do
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -TERM $pid; fi"
  end

  desc 'Start unicorn'
  task :start, :roles => :app do
    run "cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D"
  end
end

namespace :deploy do
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read("./app/views/errors/503.html.erb")
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
end

before 'deploy:restart', 'unicorn:pidof'
after 'deploy', 'deploy:cleanup' # keep only the last 5 releases
after 'deploy:cleanup', 'unicorn:pidof'
