namespace :email_uploader do
  desc "Uploads two CSV files with invalid emais and optout emails"
  task :copy_to_ftp => :environment do
    invalid = EmailMarketing::CsvUploader.new
    invalid.generate_invalid
    invalid.copy_to_ftp("invalid_email.csv")

    optout = EmailMarketing::CsvUploader.new
    optout.generate_optout
    optout.copy_to_ftp("optout_email.csv")
  end
end