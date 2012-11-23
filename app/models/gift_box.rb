class GiftBox < ActiveRecord::Base
  validates :name, :presence => true
  mount_uploader :thumb_image, ImageUploader
  has_many :gift_boxes_products, :dependent => :destroy
  has_many :products, :through => :gift_boxes_products
end
