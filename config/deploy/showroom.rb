#role :web, "domainname"
#role :app, "10.62.18.252" 
role :app, "50.16.73.208"
#role :db,  "domainname", :primary => true
 
# server details
set :rails_env, "RAILS_ENV=production"

# repo details
set :branch, 'master'

# tasks
namespace :deploy do
  task :default, :role => :app do
    update #capistrano internal default task
    yml_links
    bundle_install
    rake_tasks
    restart
  end

  desc 'Install gems'
  task :bundle_install, :roles => :app do
    run "cd #{path_app} && #{bundle} update && #{bundle} install"
  end

  desc 'Run migrations, clean assets'
  task :rake_tasks, :role => :app do
    run "cd #{path_app} && #{rake} db:migrate assets:clean assets:precompile #{rails_env}"
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
  end

  desc 'Restart webserver'
  task :restart, :roles => :app do
    run "/sbin/restart unicorn"
  end

# desc "Make sure local git is in sync with remote."
# task :check_revision, roles: :web do
#   unless `git rev-parse HEAD` == `git rev-parse origin/master`
#     puts "WARNING: HEAD is not the same as origin/master"
#     puts "Run `git push` to sync changes."
#     exit
#   end
# end
#
# before "deploy", "deploy:check_revision"

#Ao utilizar o callback after dessa forma, o Unicorn será reiniciado 2x, 1X pela task default do deploy e 1x pelo callback
  #after 'deploy', 'deploy:yml_links'
  #after 'deploy:yml_links', 'deploy:bundle_install'
  #after 'deploy:bundle_install', 'deploy:restart'
end
