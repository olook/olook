# -*- encoding : utf-8 -*-
class Detail < ActiveRecord::Base
  belongs_to :product
  
  validates :product, :presence => true
  validates :translation_token, :presence => true
  validates :description, :presence => true

  has_enumeration_for :display_on, :with => DisplayDetailOn, :required => true
  
  scope :only_invisible     , where(:display_on => DisplayDetailOn::INVISIBLE)
  scope :only_specification , where(:display_on => DisplayDetailOn::SPECIFICATION)
  scope :only_how_to        , where(:display_on => DisplayDetailOn::HOW_TO)
end
