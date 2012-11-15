class CampaignEmailNotificationMailer < ActionMailer::Base
	default :from => "olook <bemvinda@olook1.com.br>"

	def welcome_email(email)
		mail(:to => email, :subject => "Recebemos seu email com sucesso")
    
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
	end

end