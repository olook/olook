namespace :marketing_uploader do

  desc "Uploads a CSV file with all user data (user name, email, etc) and auth token"
  task :copy_userbase_to_ftp_auth_token => :environment do
    MarketingReports::Builder.new(:userbase_with_auth_token).upload("base_atualizada_purchases_auth_token.csv")
  end

end