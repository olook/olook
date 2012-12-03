# == Schema Information
#
# Table name: landing_pages
#
#  id           :integer          not null, primary key
#  page_image   :string(255)
#  page_title   :string(255)
#  page_url     :string(255)
#  button_image :string(255)
#  button_url   :string(255)
#  button_alt   :string(255)
#  enabled      :boolean
#  show_header  :boolean
#  show_footer  :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  button_top   :integer
#  button_left  :integer
#

# -*- encoding : utf-8 -*-

class LandingPage < ActiveRecord::Base
  validates :page_url, :page_title, :presence => true, :uniqueness => true
  validates :page_url, :format => { :with => /^[\w-]+$/ }
  validates :button_url, :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  validates :button_top, :inclusion => { :in => 0..1000 }, :allow_blank => true
  validates :button_left, :inclusion => { :in => 0..1000 }, :allow_blank => true

  mount_uploader :page_image, ImageUploader
  mount_uploader :button_image, ImageUploader
end
