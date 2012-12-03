# == Schema Information
#
# Table name: campaign_emails
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CampaignEmail < ActiveRecord::Base
	after_create :enqueue_notification

	def enqueue_notification
		Resque.enqueue(CampaignEmailNotificationWorker, self.email)
	end

end
