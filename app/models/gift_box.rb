class GiftBox < ActiveRecord::Base
  validates :name, :presence => true
  mount_uploader :thumb_image, ImageUploader
end
