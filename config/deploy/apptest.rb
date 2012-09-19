#role :app, 'apptest.olook.com.br'
role :web, 'apptest.olook.com.br'

# repo details
set :branch, fetch(:branch, 'master')
set :rails_env, 'staging'

namespace :assets do
  task :to_cdn do
    # set :cdn_container, "cdn-app-staging.olook.com.br"
    # AWS::S3::Base.establish_connection!(:access_key_id => cdn_user, :secret_access_key => cdn_api_key )
    # assets_dir = "#{shared_path}/assets"
    # Dir.glob(assets_dir + "/**/*").each do |file|
    #   if !File.directory?(file)
    #     cdn_filename = file.gsub(assets_dir,"assets")
    #     AWS::S3::S3Object.store(cdn_filename, open(file) , cdn_container)
    #   end
    # end
    #run "s3cmd --skip-existing --preserve --recursive sync #{shared_path}/assets s3://cdn-app-staging.olook.com.br"
  end
end

# tasks
namespace :deploy do
  task :default, :role => :web do
    #configuring_server
    update #capistrano internal default task
    #bundle_install
    #rake_tasks
    #assets_tasks
    yml_links
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
    run "cd #{path_app} && #{bundle} --without development test install"
  end

  desc 'Run migrations, clean assets'
  task :rake_tasks, :role => :app do
    run "cd #{path_app} && #{bundle} exec #{rake} db:migrate RAILS_ENV=#{rails_env}"
    run "cd #{path_app} && #{bundle} exec #{rake} olook:create_permissions RAILS_ENV=#{rails_env}"
  end

  desc 'Run assets clean and precompile'
  task :assets_tasks, :role => :app do
    run "cd #{path_app} && #{bundle} exec #{rake} assets:clean RAILS_ENV=#{rails_env}"
    run "cd #{path_app} && #{bundle} exec #{rake} assets:precompile RAILS_ENV=#{rails_env}"
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
  #after 'deploy:yml_links', 'deploy:assets:symlink'
  #after 'deploy:update_code', 'deploy:yml_links'
  #after 'deploy:yml_links', 'deploy:assets:precompile'
  #after 'deploy:assets:precompile', 'assets:to_cdn'
end
