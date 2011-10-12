# -*- encoding : utf-8 -*-
class Picture < ActiveRecord::Base
  belongs_to :product
  
  validates :image, :presence => true
  validates :product, :presence => true

  has_enumeration_for :display_on, :with => DisplayOn, :required => true
end
