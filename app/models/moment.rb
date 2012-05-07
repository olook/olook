class Moment < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :slug, :presence => true, :uniqueness => true

  mount_uploader :header_image, ImageUploader
end