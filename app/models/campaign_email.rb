class CampaignEmail < ActiveRecord::Base
  after_create :enqueue_notification
  scope :uncoverted_users , where(converted_user: false)

  validates_with CampaignEmailValidator, :attributes => [:email]
  validates :email, presence: true, format: { with: /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i }, uniqueness: true
  validates :phone, presence: true, format: { with: /[\(\)\- 0-9]{10,15}/ }, if: proc { |a| a.profile == "olookmovel" }

  before_validation :default_values

  def enqueue_notification
    Resque.enqueue(CampaignEmailNotificationWorker, self.email)
  end

  def set_utm_info utm_info
    self.update_attributes({utm_source: utm_info.fetch(:utm_source, nil),
                            utm_medium: utm_info.fetch(:utm_medium, nil),
                            utm_campaign: utm_info.fetch(:utm_campaign, nil),
                            utm_content: utm_info.fetch(:utm_content, nil)})
  end

  private

  def default_values
    self.profile ||= 'news'
  end

end
