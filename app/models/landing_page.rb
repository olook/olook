# -*- encoding : utf-8 -*-

class LandingPage < ActiveRecord::Base
  validates :page_url, :page_title, :presence => true, :uniqueness => true
  validates :page_url, :format => { :with => /^[\w-]+$/ }
  validates :button_url, :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  mount_uploader :page_image, LandingImageUploader
  mount_uploader :button_image, LandingImageUploader
end
