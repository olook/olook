# -*- encoding : utf-8 -*-

class LandingPage < ActiveRecord::Base
  validates :page_url, :page_title, :presence => true, :uniqueness => true
  validates :page_url, :format => { :with => /^[\w-]+$/ }
  mount_uploader :page_image, LandingImageUploader
  after_update :invalidate_cdn_image

  private

  def invalidate_cdn_image
    CloudfrontInvalidator.new.invalidate(self.page_image.url.slice(23..150)) unless self.page_image.url.nil?
  end
end
