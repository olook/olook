load 'deploy/assets'
require 'airbrake/capistrano'
require 'new_relic/recipes'

role :app, 'app1.olook.com.br', 'app2.olook.com.br', 'app3.olook.com.br', 'app4.olook.com.br', 'app5.olook.com.br'
role :web, 'app2.olook.com.br'
role :db,  'app2.olook.com.br'


# server details
set :rails_env, 'production'
#
# repo details
set :branch, fetch(:branch, 'master')

# tasks
namespace :deploy do
  task :default, :role => [:app, :db] do
    update #capistrano internal default task
    yml_links
    rake_tasks
    sync_task
    restart
  end

  desc 'Create symlinks'
  task :yml_links, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/database.yml #{version_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/analytics.yml #{version_path}/config/analytics.yml"
    run "ln -nfs #{deploy_to}/shared/aws.yml #{version_path}/config/aws.yml"
    run "ln -nfs #{deploy_to}/shared/fog_credentials.yml #{version_path}/config/fog_credentials.yml"
    run "ln -nfs #{deploy_to}/shared/moip.yml #{version_path}/config/moip.yml"
    run "ln -nfs #{deploy_to}/shared/newrelic.yml #{version_path}/config/newrelic.yml"
    run "ln -nfs #{deploy_to}/shared/promotions.yml #{version_path}/config/promotions.yml"
    run "ln -nfs #{deploy_to}/shared/resque.yml #{version_path}/config/resque.yml"
    run "ln -nfs #{deploy_to}/shared/yahoo.yml #{version_path}/config/yahoo.yml"
    run "ln -nfs #{deploy_to}/shared/facebook.yml #{version_path}/config/facebook.yml"
    run "ln -nfs #{deploy_to}/shared/abacos.yml #{version_path}/config/abacos.yml"
    run "ln -nfs #{deploy_to}/shared/unicorn.conf.rb #{version_path}/config/unicorn.conf.rb"
    run "ln -nfs #{deploy_to}/shared/assets #{version_path}/public/assets"
  end

  desc 'Sync assets from app2 to others'
  task :sync_task, :role => :web do
    run "cd #{deploy_to}/shared && scp -P13630 -r assets root@app3.olook.com.br:#{deploy_to}/shared/", :roles => :web
    run "cd #{deploy_to}/shared && scp -P13630 -r assets root@app4.olook.com.br:#{deploy_to}/shared/", :roles => :web
    run "cd #{deploy_to}/shared && scp -P13630 -r assets root@app5.olook.com.br:#{deploy_to}/shared/", :roles => :web
    run "cd #{deploy_to}/shared && scp -P13630 -r assets app1.olook.com.br:#{deploy_to}/shared/", :roles => :web
  end

  desc 'Run migrations'
  task :rake_tasks, :role => :db do
    run "cd #{path_app} && bundle exec rake db:migrate RAILS_ENV=#{rails_env}", :roles => :db
    run "cd #{path_app} && bundle exec rake olook:create_permissions RAILS_ENV=#{rails_env}", :roles => :db
  end

  desc 'Restart unicorn'
  task :restart, :roles => :app do
    run "ps -e -o pid,command |grep unicorn |grep master"
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -USR2 $pid; else cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D; fi"
    run "ps -e -o pid,command |grep unicorn |grep master"
  end
end

# after 'newrelic:notice_deployment', 'unicorn:pidof'
after 'deploy:cleanup', 'newrelic:notice_deployment'
