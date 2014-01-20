class WishedProduct < ActiveRecord::Base
  attr_accessible :retail_price, :wishlist_id, :variant_id

  belongs_to :variant
  belongs_to :wishlist
end