class HighlightCampaign < ActiveRecord::Base
  attr_accessible :label
  validates :label, presence: true
end
