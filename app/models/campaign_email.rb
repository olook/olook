class CampaignEmail < ActiveRecord::Base
  after_create :enqueue_notification

  def enqueue_notification
	Resque.enqueue(CampaignEmailNotificationWorker, self.email)
  end

  def set_utm_info utm_info
      self.update_attributes({utm_source: utm_info.fetch(:utm_source, nil),
                              utm_medium: utm_info.fetch(:utm_medium, nil),
                              utm_campaign: utm_info.fetch(:utm_campaign, nil),
                              utm_content: utm_info.fetch(:utm_content, nil)})
  end

end
