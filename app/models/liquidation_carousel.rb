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
