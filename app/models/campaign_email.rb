class CampaignEmail < ActiveRecord::Base
	after_create :enqueue_notification

	def enqueue_notification
		Resque.enqueue(CampaignEmailNotificationWorker, self.email)
	end

  def self.with_discount_about_to_expire_in_48_hours
    where(created_at: (Date.today - DiscountExpirationCheckService.days_until_warning.days).beginning_of_day..(Date.today - DiscountExpirationCheckService.days_until_warning.days).end_of_day).collect(&:email)
  end

end
