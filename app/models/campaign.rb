class Campaign < ActiveRecord::Base
  validate :start_at, :presence => true
  mount_uploader :lightbox, ImageUploader
  mount_uploader :banner, ImageUploader
end
