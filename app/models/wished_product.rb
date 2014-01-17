class WishedProduct < ActiveRecord::Base
  attr_accessible :retail_price, :wishlist_id

  belongs_to :variant
end
