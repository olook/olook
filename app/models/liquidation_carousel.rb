# == Schema Information
#
# Table name: liquidation_carousels
#
#  id             :integer          not null, primary key
#  liquidation_id :integer
#  image          :string(255)
#  order          :integer
#  created_at     :datetime
#  updated_at     :datetime
#  product_id     :integer
#

class LiquidationCarousel < ActiveRecord::Base
  validates_each :product_id do |record, attr, value|
    unless  Liquidation.find(record.liquidation_id).resume[:products_ids].include? value
      message = "The product_id is not inserted in liquidation"
      record.errors.add(:product_id, message)
    end
  end
  belongs_to :liquidation

  mount_uploader :image, ImageUploader
end
