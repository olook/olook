#role :app, 'apptest.olook.com.br'
role :web, 'apptest.olook.com.br'

# repo details
set :branch, fetch(:branch, 'master')
#set :rails_env, "staging"

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

# tasks
namespace :deploy do
  task :default, :role => :web do
    #configuring_server
    update #capistrano internal default task
    #bundle_install
    yml_links
    rake_tasks
    restart
  end

  desc 'Seting Up'
  task :configuring_server, :roles => :web do
    run "mkdir /srv/olook/#{branch}"
    set :path_app, "/srv/olook/#{branch}"
    setup
    cold
  end

  desc 'Install gems'
  task :bundle_install, :roles => :web do
    #run "cd #{path_app} && #{bundle} --without development test install"
  end

  desc 'Run migrations, clean assets'
  task :rake_tasks, :role => :web do
    run "cd #{path_app} && bundle exec #{rake} db:migrate RAILS_ENV=#{rails_env}"
    #run "cd #{path_app} && bundle exec #{rake} assets:clean RAILS_ENV=#{rails_env}"
    #run "cd #{path_app} && bundle exec #{rake} assets:precompile RAILS_ENV=#{rails_env}"
    run "cd #{path_app} && bundle exec #{rake} olook:create_permissions RAILS_ENV=#{rails_env}"
  end

  desc 'Create symlinks'
  task :yml_links, :roles => :web do
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

  desc 'Stop unicorn'
  task :stop_unicorn, :roles => :web do
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -TERM $pid; fi"
  end

  desc 'Start unicorn'
  task :start_unicorn, :roles => :web do
    run "cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D"
  end

  desc 'Restart unicorn'
  task :restart, :roles => :web do
    run "ps -e -o pid,command |grep unicorn |grep master"
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -USR2 $pid; else cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D; fi"
  end

  #after 'deploy:update', 'deploy:bundle_install' # keep only the last 5 releases
  #before 'deploy:assets:precompile', 'deploy:bundle_install'

  #before 'deploy:finalize_update', 'deploy:assets:symlink'
  #after 'deploy:update_code', 'deploy:assets:precompile'
end
