namespace :invites do
  desc "Resend invites for those who haven't accepted it yet"
  task :resend => :environment do
    InvitesProcessing.new.catalog
  end
end
