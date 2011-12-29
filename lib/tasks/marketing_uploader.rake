namespace :marketing_uploader do
  desc "Uploads two CSV files with invalid emails and optout emails"
  task :copy_email_to_ftp => :environment do
    EmailMarketing::CsvUploader.new(:invalid).copy_to_ftp("invalid_email.csv")
    EmailMarketing::CsvUploader.new(:optout).copy_to_ftp("optout_email.csv")
  end

  desc "Uploads a CSV file with all user data (user name, email, etc)"
  task :copy_userbase_to_ftp => :environment do
    EmailMarketing::CsvUploader.new(:userbase).copy_to_ftp("base_atualizada.csv")
  end

  desc "Uploads a CSV with userbase orders"
  task :copy_userbase_orders => :environment do
    EmailMarketing::CsvUploader.new(:userbase_orders).copy_to_ftp("base_pedidos_atualizada.csv")
  end

end