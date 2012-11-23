class GiftBoxesProducts < ActiveRecord::Base
  belongs_to :gift_box
  belongs_to :products
end
