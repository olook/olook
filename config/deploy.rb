require 'capistrano/ext/multistage'
require "bundler/capistrano"

set :stages, %w(prod1 prod2 prod3 hmg dev resque showroom new_machine)
#set :default_stage, "dev"

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

# repo details
set :scm, :git
set :repository, 'git@github.com:olook/olook.git'
set :git_enable_submodules, 1
 
default_run_options[:pty] = true
ssh_options[:port] = 13630
ssh_options[:forward_agent] = true
