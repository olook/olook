namespace :email_uploader do
  desc "Uploads two CSV files with invalid emais and optout emails"
  task :copy_to_ftp => :environment do
    EmailMarketing::CsvUploader.new(:invalid).copy_to_ftp("invalid_email.csv")
    EmailMarketing::CsvUploader.new(:optout).copy_to_ftp("optout_email.csv")
  end
end