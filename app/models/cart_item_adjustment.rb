class CartItemAdjustment < ActiveRecord::Base
  belongs_to :cart_item
  validates :value, presence: true
  validates :cart_item_id, presence: true
end
