# -*- encoding : utf-8 -*-
class CampaignPage < ActiveRecord::Base

  belongs_to :campaign
  belongs_to :page

  validates :campaign_id, :page_id, :presence => true
end
