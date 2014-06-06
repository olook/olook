class CampaignEmailNotificationWorker
	@queue = 'low'

	def self.perform(email)
		newsletter_record = CampaignEmail.where(email: email).first
    if newsletter_record && newsletter_record.profile == 'olookmovel'
      mail = CampaignEmailNotificationMailer.olookmovel_welcome_email(email)
    else
      mail = CampaignEmailNotificationMailer.welcome_email(email)
    end
    mail.deliver
  end
end
