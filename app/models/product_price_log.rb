class ProductPriceLog < ActiveRecord::Base
  attr_accessible :price, :product_id, :retail_price
  validates :price, :retail_price, :product_id, presence: true
  belongs_to :product
end
