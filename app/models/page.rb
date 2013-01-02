class Page < ActiveRecord::Base
  has_many :campaign_pages
  has_many :campaigns, :through => :campaign_pages
end
