# -*- encoding : utf-8 -*-
class CampaignEmailNotificationMailer < ActionMailer::Base
	default :from => "olook <bemvinda@olook1.com.br>"

	def welcome_email(email)
		mail(:to => email, :subject => "Use agora mesmo seus 20% de desconto!")
    
    headers["X-SMTPAPI"] = { 'category' => 'welcome_email' }.to_json
	end

end