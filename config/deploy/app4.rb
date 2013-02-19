# load 'deploy/assets'

role :app, "app4.olook.com.br"
role :web, "app4.olook.com.br"
# server details
set :rails_env, 'production'

# repo details
set :branch, fetch(:branch, 'app4')

# tasks
namespace :deploy do

  task :default, :role => :app do
    update #capistrano internal default task
    yml_links
    # rake_tasks
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
  end

  # desc 'Run migrations'
  # task :rake_tasks, :role => :app do
  #   run "cd #{path_app} && bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
  #   run "cd #{path_app} && bundle exec rake olook:create_permissions RAILS_ENV=#{rails_env}"
  # end

  desc 'Restart webserver'
  task :restart, :roles => :app do
    run "ps -e -o pid,command |grep unicorn |grep master"
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -USR2 $pid; else cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D; fi"
    run "ps -e -o pid,command |grep unicorn |grep master"
  end

end
