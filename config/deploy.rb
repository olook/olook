namespace :deploy do

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
