class Brand < ActiveRecord::Base
  attr_accessible :header_image, :header_image_alt, :name
  validates :name, presence: true
  validates :header_image, presence: true
  mount_uploader :header_image, ImageUploader
end
