class HighlightCampaign < ActiveRecord::Base
  attr_accessible :label
  validates :label, presence: true
  has_and_belongs_to_many :products
end
