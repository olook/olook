# This is a sample Capistrano config file for rubber
require File.expand_path(File.join(File.dirname(__FILE__), 'deploy', 'capistrano_yml_config.rb'))

set :rails_env, Rubber.env

on :load do
  set :application, rubber_env.app_name
  set :runner,      rubber_env.app_user
  set :deploy_to,   "/mnt/#{application}-#{Rubber.env}"
  set :copy_exclude, [".git/*", ".bundle/*", "log/*", ".rvmrc", ".rbenv-version"]
end

# Use a simple directory tree copy here to make demo easier.
# You probably want to use your own repository for a real app
ssh_options[:forward_agent] = true #optional : for deploy from github

set :scm, 'git'
set :repository, "git@github.com:olook/olook.git"
set :deploy_via, :remote_cache
set :branch, fetch(:branch, 'master')

# Easier to do system level config as root - probably should do it through
# sudo in the future.  We use ssh keys for access, so no passwd needed
set :user, 'root'
set :password, nil

# Use sudo with user rails for cap deploy:[stop|start|restart]
# This way exposed services (mongrel) aren't running as a privileged user
set :use_sudo, true

# How many old releases should be kept around when running "cleanup" task
set :keep_releases, 5

# Lets us work with staging instances without having to checkin config files
# (instance*.yml + rubber*.yml) for a deploy.  This gives us the
# convenience of not having to checkin files for staging, as well as
# the safety of forcing it to be checked in for production.
set :push_instance_config, Rubber.env != 'production'

# don't waste time bundling gems that don't need to be there
set :bundle_without, [:development, :test, :staging] if Rubber.env == 'production'

# Allow us to do N hosts at a time for all tasks - useful when trying
# to figure out which host in a large set is down:
# RUBBER_ENV=production MAX_HOSTS=1 cap invoke COMMAND=hostname
max_hosts = ENV['MAX_HOSTS'].to_i
default_run_options[:max_hosts] = max_hosts if max_hosts > 0

# Allows the tasks defined to fail gracefully if there are no hosts for them.
# Comment out or use "required_task" for default cap behavior of a hard failure
rubber.allow_optional_tasks(self)

# Wrap tasks in the deploy namespace that have roles so that we can use FILTER
# with something like a deploy:cold which tries to run deploy:migrate but can't
# because we filtered out the :db role
namespace :deploy do
  rubber.allow_optional_tasks(self)
  tasks.values.each do |t|
    if t.options[:roles]
      task t.name, t.options, &t.body
    end
  end
end

namespace :deploy do
  namespace :assets do
    rubber.allow_optional_tasks(self)
    tasks.values.each do |t|
      if t.options[:roles]
        task t.name, t.options, &t.body
      end
    end
  end
end

# load in the deploy scripts installed by vulcanize for each rubber module
Dir["#{File.dirname(__FILE__)}/rubber/deploy-*.rb"].each do |deploy_file|
  load deploy_file
end

if Rubber.env == 'production'
  require 'airbrake/capistrano'
  require 'new_relic/recipes'
  after "deploy", "newrelic:notice_deployment"
end

# capistrano's deploy:cleanup doesn't play well with FILTER
after "deploy", "cleanup"
after "deploy:migrations", "cleanup"
task :cleanup, :except => { :no_release => true } do
  count = fetch(:keep_releases, 5).to_i

  rsudo <<-CMD
    all=$(ls -x1 #{releases_path} | sort -n);
    keep=$(ls -x1 #{releases_path} | sort -n | tail -n #{count});
    remove=$(comm -23 <(echo -e "$all") <(echo -e "$keep"));
    for r in $remove; do rm -rf #{releases_path}/$r; done;
  CMD
end

namespace :deploy do
  namespace :public do
    task :symlink, :except => { :no_release => true } do
      run <<-CMD.compact
        rm -rf #{latest_release}/public/uploads &&
        mkdir -p #{latest_release}/public &&
        mkdir -p #{shared_path}/uploads &&
        ln -s #{shared_path}/uploads #{latest_release}/public/uploads
      CMD
    end
  end
end

namespace :deploy do
  namespace :tmp do
    task :symlink, :except => { :no_release => true } do
      run <<-CMD.compact
        rm -rf #{latest_release}/tmp &&
        mkdir -p #{latest_release}/tmp &&
        mkdir -p #{shared_path}/tmp &&
        ln -s #{shared_path}/tmp #{latest_release}/tmp
      CMD
    end
  end
end

# load asset pipeline tasks, and reorder them to run after
# rubber:config so that database.yml/etc has been generated
load 'deploy/assets'
callbacks[:after].delete_if {|c| c.source == "deploy:assets:precompile"}
callbacks[:before].delete_if {|c| c.source == "deploy:assets:symlink"}
before "deploy:assets:precompile", "deploy:tmp:symlink"
before "deploy:assets:precompile", "deploy:public:symlink"
before "deploy:assets:precompile", "deploy:assets:symlink"
after "rubber:config", "deploy:assets:precompile"
