role :app, 'app1.olook.com.br'
 
# server details
set :env, 'production'

# repo details
set :branch, fetch(:branch, 'master')

# tasks
namespace :deploy do
  task :default, :role => :app do
    update #capistrano internal default task
    yml_links
    #bundle_install
    #rake_tasks
    #assets_tasks
    restart
  end

  desc 'Install gems'
  task :bundle_install, :roles => :app do
    run "cd #{path_app} && #{bundle} --without development test install"    
  end

  desc 'Run migrations, clean assets'
  task :rake_tasks, :role => :app do
    run "cd #{path_app} && #{bundle} exec #{rake} db:migrate RAILS_ENV=#{env}"
    run "cd #{path_app} && #{bundle} exec #{rake} olook:create_permissions RAILS_ENV=#{env}"
  end

  desc 'Run assets clean and precompile'
  task :assets_tasks, :role => :app do
    run "cd #{path_app} && #{bundle} exec #{rake} assets:clean RAILS_ENV=#{env}"
    run "cd #{path_app} && #{bundle} exec #{rake} assets:precompile RAILS_ENV=#{env}"
  end

  desc 'Create symlinks'
  task :yml_links, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/database.yml #{version_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/analytics.yml #{version_path}/config/analytics.yml"
    run "ln -nfs #{deploy_to}/shared/aws.yml #{version_path}/config/aws.yml"
    run "ln -nfs #{deploy_to}/shared/criteo.yml #{version_path}/config/criteo.yml"
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

  desc 'Stop webserver'
  task :stop_unicorn, :roles => :app do
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -TERM $pid; fi"
  end 

  desc 'Start webserver'
  task :start_unicorn, :roles => :app do
    run "cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{env} -D"
  end 

  desc 'Restart webserver'
  task :restart, :roles => :app do
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -USR2 $pid; else cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{env} -D; fi"
  end
end
