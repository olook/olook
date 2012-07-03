# -*- encoding : utf-8 -*-
class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :variant
  
  
end