class Campaign < ActiveRecord::Base
  validates :title, :presence => true
  validates :start_at, :presence => true
  validates :end_at, :presence => true
  mount_uploader :lightbox, ImageUploader
  mount_uploader :banner, ImageUploader
end
