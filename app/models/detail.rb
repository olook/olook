# -*- encoding : utf-8 -*-
class Detail < ActiveRecord::Base
  belongs_to :product
  
  validates :product, :presence => true
  validates :translation_token, :presence => true
  validates :description, :presence => true

  has_enumeration_for :display_on, :with => DisplayDetailOn, :required => true
end
