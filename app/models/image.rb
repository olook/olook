# -*- encoding : utf-8 -*-
class Image < ActiveRecord::Base
	belongs_to :lookbook
  validates :lookbook, :presence => true
  mount_uploader :image, ImageUploader
  after_update :invalidate_cdn_image

  private

  def invalidate_cdn_image
    CloudfrontInvalidator.new.invalidate(self.image.url.slice(23..150)) unless self.image.url.nil?
  end
end
