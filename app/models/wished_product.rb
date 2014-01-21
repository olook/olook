class WishedProduct < ActiveRecord::Base
  attr_accessible :retail_price, :wishlist_id, :variant_id

  belongs_to :variant
  belongs_to :wishlist

  def product_id
    variant.product_id
  end

  def variant_number
    variant.number
  end
end