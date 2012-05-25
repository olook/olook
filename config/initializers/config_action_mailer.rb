ActionMailer::Base.smtp_settings = {
  :user_name => "olook2",
  :password => "olook123abc",
  :domain => "my.olookmail.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto =>  true
}
