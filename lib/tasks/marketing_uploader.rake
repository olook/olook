namespace :marketing_uploader do
  desc "Uploads two CSV files with invalid emails and optout emails"
  task :copy_email_to_ftp => :environment do
    MarketingReports::Builder.new(:invalid).upload("invalid_email.csv")
    MarketingReports::Builder.new(:optout).upload("optout_email.csv")
  end

  desc "Uploads a CSV file with all user data (user name, email, etc)"
  task :copy_userbase_to_ftp => :environment do
    MarketingReports::Builder.new(:userbase).upload("base_atualizada_purchases.csv")
  end

  desc "Uploads a CSV with userbase orders"
  task :copy_userbase_orders_to_ftp => :environment do
    MarketingReports::Builder.new(:userbase_orders).upload("base_pedidos_atualizada.csv")
  end

  desc "Uploads a CSV with userbase revenue"
  task :copy_userbase_revenue_to_ftp => :environment do
    MarketingReports::Builder.new(:userbase_revenue).upload("base_receita_atualizada.csv")
  end

end