class Campaign < ActiveRecord::Base
  validates :title, :presence => true
  validates :start_at, :presence => true
  validates :end_at, :presence => true
  validates :background, :presence => true
  validate :only_one_activated?
  mount_uploader :banner, ImageUploader

  def is_active?
    start_at <= Date.today && end_at >= Date.today
  end

  def only_one_activated?
    errors.add(:is_active, ": sorry, but only one campaign can be active at the same time. Deactivate an existing one before you proceed") if Campaign.any_campaign_active_today?(self) && Campaign.invalid_range?(self)
  end

  def self.any_campaign_active_today?(campaign = nil)
    campaign_exists?(campaign) ? check_period_excluding_campaign(campaign) : check_period_campaign
  end

  def self.invalid_range?(campaign)
    campaign_exists?(campaign) ? check_range_excluding_campaign(campaign) : check_range_campaign(campaign)
  end

  def self.activated_campaign
    where("start_at <= '#{Date.today}' AND end_at >= '#{Date.today}'").first if any_campaign_active_today?
  end

  private

  def self.campaign_exists?(campaign)
    campaign.try(:id)
  end

  def self.check_period_excluding_campaign(campaign)
    !where("start_at <= '#{Date.today}' AND end_at >= '#{Date.today}' AND id != #{ campaign.id }").empty?
  end

  def self.check_period_campaign
    !where("start_at <= '#{Date.today}' AND end_at >= '#{Date.today}'").empty?
  end

  def self.check_range_excluding_campaign(campaign)
    !where("start_at <= '#{ campaign.start_at }' AND end_at >= '#{ campaign.start_at }' AND id != #{ campaign.id }").empty? || !where("start_at <= '#{ campaign.end_at }' AND end_at >= '#{ campaign.end_at }' AND id != #{ campaign.id }").empty?
  end

  def self.check_range_campaign(campaign)
    !where("start_at <= '#{ campaign.start_at }' AND end_at >= '#{ campaign.start_at }'").empty? || !where("start_at <= '#{ campaign.end_at }' AND end_at >= '#{ campaign.end_at }'").empty?
  end

end

