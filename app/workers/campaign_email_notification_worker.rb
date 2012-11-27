class CampaignEmailNotificationWorker
	@queue = :mailer

	def self.perform(email)
    mail = CampaignEmailNotificationMailer.welcome_email(email)
    mail.deliver
  end
end