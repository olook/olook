# -*- encoding : utf-8 -*-

class LandingPage < ActiveRecord::Base
  validates :page_url, :page_title, :presence => true, :uniqueness => true
  validates :page_url, :format => { :with => /^[\w-]+$/ }
end
