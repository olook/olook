class CampaignEmail < ActiveRecord::Base
	after_create :enqueue_notification

	def enqueue_notification
		Resque.enqueue(CampaignEmailNotificationWorker, self.email)
	end

end
