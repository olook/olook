class CampaignEmailNotificationMailer < ActionMailer::Base
	default :from => "olook <bemvinda@olook1.com.br>"

  def self.smtp_settings
    {
      :user_name => "olook2",
      :password => "olook123abc",
      :domain => "my.olookmail.com",
      :address => "smtp.sendgrid.net",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

	def welcome_email(email)
		mail(:to => email, :subject => "Recebemos seu email com sucesso")
    
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
	end

end