class CampaignEmail < ActiveRecord::Base
	after_create :enqueue_notification

	def enqueue_notification
		Resque.enqueue(CampaignEmailNotificationWorker, self.email)
	end

  def self.with_discount_about_to_expire_in_48_hours
    where(created_at: (Date.today - 5.days).beginning_of_day..(Date.today - 5.days).end_of_day).to_a
  end

end
