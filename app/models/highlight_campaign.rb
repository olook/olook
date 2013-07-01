class HighlightCampaign < ActiveRecord::Base
  attr_accessible :label, :product_ids
  validates :label, presence: true
end
