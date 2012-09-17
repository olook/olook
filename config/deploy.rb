require 'airbrake/capistrano'
require 'new_relic/recipes'
require 'capistrano/ext/multistage'
require 'aws/s3'

load 'deploy/assets'
require 'bundler/capistrano'

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
set :rake, '/usr/local/ruby/bin/rake'

set :path_log, '/mnt/debug'
# set :rails_env, "RAILS_ENV=production"
set :rails_env, "production"
set :env, 'production'

# repo details
set :scm, :git
set :repository, 'git@github.com:olook/olook.git'
set :git_enable_submodules, 1

# s3 details
set :cdn_user, 'AKIAJ2WH3XLYA24UTAJQ'
set :cdn_api_key, 'M1d4JbTo9faMber0MKPeO2dzM6RsXNJqrOTBrsZX'

default_run_options[:pty] = true
ssh_options[:port] = 13630
ssh_options[:forward_agent] = true

#after 'deploy:update', 'newrelic:notice_deployment'
after 'deploy', 'deploy:cleanup' # keep only the last 5 releases
