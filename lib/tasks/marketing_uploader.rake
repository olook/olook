namespace :marketing_uploader do

  desc "Uploads a CSV file with all user data (user name, email, etc) and auth token"
  task :copy_userbase_to_ftp_auth_token => :environment do
    MarketingUploaderWorker.perform
  end

end