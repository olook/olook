# -*- encoding : utf-8 -*-
class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :variant
  
  delegate :product, :to => :variant, :prefix => false
  delegate :name, :to => :variant, :prefix => false
  delegate :description, :to => :variant, :prefix => false
  delegate :thumb_picture, :to => :variant, :prefix => false
  delegate :color_name, :to => :variant, :prefix => false
  
  def promotion?
    price != retail_price
  end
  
  def total_price
    price * quantity
  end
  
  def total_retail_price
    retail_price * quantity
  end
  
end