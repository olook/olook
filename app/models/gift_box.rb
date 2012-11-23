class GiftBox < ActiveRecord::Base
  validates :name, :presence => true
  validates :active, :presence => true
  validates :thumb_image, :presence => true
  mount_uploader :thumb_image, ImageUploader
end
