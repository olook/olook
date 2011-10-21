# -*- encoding : utf-8 -*-
class Detail < ActiveRecord::Base
  belongs_to :product
  
  validates :product, :presence => true
  validates :translation_token, :presence => true
  validates :description, :presence => true

  has_enumeration_for :display_on, :with => DisplayDetailOn, :required => true
  
  scope :visible  , where("display_on <> :visible", :visible => DisplayDetailOn::INVISIBLE)
  scope :invisible, where(:display_on => DisplayDetailOn::INVISIBLE)
end
