# -*- encoding : utf-8 -*-

class LandingPage < ActiveRecord::Base
  validates :page_image, :page_url, :page_title, :presence => true
  validates :page_url, :format => { :with => /^[\w-]+$/ }
end
