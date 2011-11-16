# -*- encoding : utf-8 -*-
class Variant < ActiveRecord::Base
  belongs_to :product
  
  validates :product, :presence => true
  validates :number, :presence => true
  validates :description, :presence => true
  validates :display_reference, :presence => true

  validates :price, :presence => true, :numericality => {:greater_than => 0}
  validates :inventory, :presence => true, :numericality => {:greater_than => 0, :only_integer => true}

  validates :width, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}
  validates :height, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}
  validates :length, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}
  validates :weight, :presence => true, :numericality => {:greater_than_or_equal_to => 0.0}
  
  def sku
    "#{product.model_number}-#{number}"
  end
  
  def dimensions
    "#{self.width}x#{self.height}x#{self.length} cm"
  end
 
  def volume
    ((self.width * self.height * self.length)/1000000).round 2 # in cubic meters
  end
end
