class GiftBoxesProduct < ActiveRecord::Base
  belongs_to :gift_box
  belongs_to :product
end
