class HighlightCampaign < ActiveRecord::Base
  attr_accessible :label, :product_ids
  validates :label, presence: true
  has_and_belongs_to_many :products

  def add_products string
    return {code: "2",fail_product_ids: []} if string.blank?
    product_ids = string.split(',')
  end
end
