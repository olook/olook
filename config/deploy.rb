require 'bundler/capistrano'

set :application, "107.20.157.90"
set :repository,  "git@github.com:olook/olook.git"
set :user, "deploy"
set :password, "1ppp2pxp"
set :deploy_to, "/srv/olook"
set :scm, :git
set :port, 22
server application, :app, :web, :db, :primary => true
set :deploy_via, :remote_cache

namespace :deploy do
  task :start do; end
  task :stop do; end

  desc "Pull repository and checkout to assigned tag"
  task :pull_and_checkout do
    run "git pull && git checkout #{ref}"
  end

  desc "Generate assets packages"
  task :generate_assets_packages do
    run "rake asset:packager:build_all RAILS_ENV=production"
  end

end

after "deploy:pull_and_checkout", "deploy:migrate"
after "deploy:migrate", "deploy:generate_assets_packages"
