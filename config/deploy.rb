require 'bundler/capistrano'

<<<<<<< HEAD
set :application, "localhost"
set :repository,  "git@github.com:olook/olook.git"
set :user, "deploy"
set :password, ""
=======
set :application, "107.20.157.90"
set :repository,  "git@github.com:olook/olook.git"
set :user, "deploy"
set :password, "1ppp2pxp"
>>>>>>> master
set :deploy_to, "/srv/olook"
set :scm, :git
set :port, 22
server application, :app, :web, :db, :primary => true
set :deploy_via, :remote_cache

<<<<<<< HEAD
# Pending: RVM will be removed from the servers and substituted by rbenv.
set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.2-p180@olook/bin:/usr/local/rvm/bin:/usr/local/rvm/rubies/ruby-1.9.2-p180/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.2-p180@olook',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.2-p180@olook',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.2-p180@olook'
}

=======
>>>>>>> master
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
