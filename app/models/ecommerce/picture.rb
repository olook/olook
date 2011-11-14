# -*- encoding : utf-8 -*-
class Picture < ActiveRecord::Base
  belongs_to :product
  
  validates :product, :presence => true

  has_enumeration_for :display_on, :with => DisplayPictureOn, :required => true
  
  mount_uploader :image, PictureUploader
end
