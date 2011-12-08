ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => 'avisos@olook.com.br',
  :password             => 'olook123abc',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}
