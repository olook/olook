class CampaignEmail < ActiveRecord::Base
  after_create :enqueue_notification
  scope :uncoverted_users , where(converted_user: false)

  validates_with CampaignEmailValidator, :attributes => [:email], unless: -> {converted_user}
  validates :email, presence: true, format: { with: /\A\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b\z/i }, uniqueness: true

  before_validation :default_values

  # has_many :campaign_emails_products
  # has_many :products, through: CampaignEmailsProducts
  has_and_belongs_to_many :products, :join_table => "campaign_emails_products", :foreign_key => "campaign_email_id"

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
