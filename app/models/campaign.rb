# == Schema Information
#
# Table name: campaigns
#
#  id          :integer          not null, primary key
#  start_at    :date
#  end_at      :date
#  banner      :string(255)
#  background  :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  title       :string(255)
#  link        :string(255)
#

class Campaign < ActiveRecord::Base
  validates :title, :presence => true
  validates :start_at, :presence => true
  validates :end_at, :presence => true
  validate :only_one_activated?
  mount_uploader :banner, ImageUploader

  def is_active?
    start_at <= Date.today && end_at >= Date.today
  end

  def only_one_activated?
    conflictant_campaigns = Campaign.all.select { |campaign| campaign.overlaps?(self) && campaign.id != self.id }

    errors.add(:is_active, ": Foi detectado um conflito de datas com a campanha #{conflictant_campaigns[0].description}.") if conflictant_campaigns.any?
  end

  def self.activated_campaign(date=Date.today)
    where("start_at <= '#{date}' AND end_at >= '#{date}'").first
  end

  def overlaps? another_campaign
    start_at.between?(another_campaign.start_at, another_campaign.end_at) || end_at.between?(another_campaign.start_at, another_campaign.end_at)
  end
end

