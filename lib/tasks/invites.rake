namespace :invites do
  desc "Resend invites for those who haven't accepted it yet"
  task :resend do
    InvitesProcessing
  end
end
