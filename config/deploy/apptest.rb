role :app, 'apptest.olook.com.br'
role :web, 'apptest.olook.com.br'

# repo details
set :branch, fetch(:branch, 'master')

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
  task :default, :role => :app do
    #configuring_server
    update #capistrano internal default task
    #bundle_install
    yml_links
    rake_tasks
    restart
  end

  desc 'Seting Up'
  task :configuring_server, :roles => :app do
    run "mkdir /srv/olook/#{branch}"
    set :path_app, "/srv/olook/#{branch}"
    setup
    cold
  end

  desc 'Install gems'
  task :bundle_install, :roles => :app do
    #run "cd #{path_app} && #{bundle} --without development test install"
  end

  desc 'Run migrations, clean assets'
  task :rake_tasks, :role => :app do
    run "cd #{path_app} && #{bundle} exec #{rake} db:migrate RAILS_ENV=#{rails_env}"
    #run "cd #{path_app} && #{bundle} exec #{rake} assets:clean RAILS_ENV=#{rails_env}"
    #run "cd #{path_app} && #{bundle} exec #{rake} assets:precompile RAILS_ENV=#{rails_env}"
    run "cd #{path_app} && #{bundle} exec #{rake} olook:create_permissions RAILS_ENV=#{rails_env}"
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








  # namespace :assets do
  #   desc <<-DESC
  #     [internal] This task will set up a symlink to the shared directory
  #     for the assets directory. Assets are shared across deploys to avoid
  #     mid-deploy mismatches between old application html asking for assets
  #     and getting a 404 file not found error. The assets cache is shared
  #     for efficiency. If you customize the assets path prefix, override the
  #     :assets_prefix variable to match.
  #   DESC
  #   task :symlink, :roles => assets_role, :except => { :no_release => true } do
  #     run <<-CMD
  #       rm -rf #{latest_release}/public/#{assets_prefix} &&
  #       mkdir -p #{latest_release}/public &&
  #       mkdir -p #{shared_path}/assets &&
  #       ln -s #{shared_path}/assets #{latest_release}/public/#{assets_prefix}
  #     CMD
  #   end

  #   desc <<-DESC
  #     Run the asset precompilation rake task. You can specify the full path
  #     to the rake executable by setting the rake variable. You can also
  #     specify additional environment variables to pass to rake via the
  #     asset_env variable. The defaults are:

  #     set :rake,      "rake"
  #     set :rails_env, "production"
  #     set :asset_env, "RAILS_GROUPS=assets"
  #   DESC
  #   task :precompile, :roles => assets_role, :except => { :no_release => true } do
  #     run "cd #{latest_release} && #{bundle} exec #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
  #   end

  #   desc <<-DESC
  #     Run the asset clean rake task. Use with caution, this will delete
  #     all of your compiled assets. You can specify the full path
  #     to the rake executable by setting the rake variable. You can also
  #     specify additional environment variables to pass to rake via the
  #     asset_env variable. The defaults are:

  #     set :rake,      "rake"
  #     set :rails_env, "production"
  #     set :asset_env, "RAILS_GROUPS=assets"
  #   DESC
  #   task :clean, :roles => assets_role, :except => { :no_release => true } do
  #     run "cd #{latest_release} && #{bundle} exec #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:clean"
  #   end
  # end


  desc 'Stop unicorn'
  task :stop_unicorn, :roles => :app do
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -TERM $pid; fi"
  end

  desc 'Start unicorn'
  task :start_unicorn, :roles => :app do
    run "cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D"
  end

  desc 'Restart unicorn'
  task :restart, :roles => :app do
    run "if [ -f /var/run/olook-unicorn.pid ]; then pid=`cat /var/run/olook-unicorn.pid` && kill -USR2 $pid; else cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D; fi"
  end

  #after 'deploy:update', 'deploy:bundle_install' # keep only the last 5 releases
  #before 'deploy:assets:precompile', 'deploy:bundle_install'

  before 'deploy:finalize_update', 'deploy:assets:symlink'
  after 'deploy:update_code', 'deploy:assets:precompile'
end
