namespace :db do
  desc "Restore cep base from mysql dump"

  task :cep_restore, :path do |t,args|
    FILE_DIR = "#{Rails.root}/config/database.yml"
    db_user = YAML::load(File.open(FILE_DIR))[Rails.env]["username"]
    db_password = YAML::load(File.open(FILE_DIR))[Rails.env]["password"]
    db_base = YAML::load(File.open(FILE_DIR))[Rails.env]["database"]
    system "mysql -u#{db_user} -p#{db_password} #{db_base} < #{args.path}"
  end
end
