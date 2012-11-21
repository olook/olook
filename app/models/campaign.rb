class Campaign < ActiveRecord::Base
  validates :title, :presence => true
  validates :start_at, :presence => true
  validates :end_at, :presence => true
  # validates :background, :presence => true
  validate :only_one_activated?
  mount_uploader :banner, ImageUploader

  def is_active?
    start_at <= Date.today && end_at >= Date.today
  end

  def only_one_activated?
    conflictant_campaigns = Campaign.all.select { |campaign| campaign.overlaps?(self) && campaign.id != self.id }
    if conflictant_campaigns.any? 
      errors.add(:is_active, ": Foi detectado um conflito de datas com a campanha #{conflictant_campaigns[0].description}.")
    end
  end

  def self.any_campaign_active_today?(campaign = nil)
    campaign_exists?(campaign) ? check_period_excluding_campaign(campaign) : check_period_campaign
  end

  def self.invalid_range?(campaign)
    campaign.start_at > campaign.end_at
  end

  def self.activated_campaign(date=Date.today)
    where("start_at <= '#{date}' AND end_at >= '#{date}'").first if any_campaign_active_today?
  end

  def overlaps? another_campaign
    start_at.between?(another_campaign.start_at, another_campaign.end_at) || end_at.between?(another_campaign.start_at, another_campaign.end_at)
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

