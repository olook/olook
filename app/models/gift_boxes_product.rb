# == Schema Information
#
# Table name: gift_boxes_products
#
#  id          :integer          not null, primary key
#  gift_box_id :integer
#  product_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GiftBoxesProduct < ActiveRecord::Base
  belongs_to :gift_box
  belongs_to :product
end
