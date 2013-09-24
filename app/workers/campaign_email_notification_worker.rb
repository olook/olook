class CampaignEmailNotificationWorker
	@queue = :mailer

	def self.perform(email)
    if CampaignEmail.where(email: email).first.profile == 'olookmovel'
      mail = CampaignEmailNotificationMailer.olookmovel_welcome_email(email)
    else
      mail = CampaignEmailNotificationMailer.welcome_email(email)
    end
    mail.deliver
  end
end
