class HighlightCampaign < ActiveRecord::Base
  attr_accessible :label, :product_ids
  validates :label, presence: true
  has_and_belongs_to_many :products

  def add_products string
    return {code: "2",fail_product_ids: []} if string.blank?
    fail_product_ids = []
    product_ids = string.split(',')
    product_ids.each do |product|
      _product = Product.find_by_id(product.to_i)
      if _product
        products << _product
      else
        fail_product_ids << product
      end
    end
    code = fail_product_ids.empty? ? "0" : "1"
    {code: code,fail_product_ids: fail_product_ids}
  end
end
