# -*- encoding : utf-8 -*-
class Cart < ActiveRecord::Base
  DEFAULT_QUANTITY = 1
  
  belongs_to :user
  has_one :order
  has_many :items, :class_name => "CartItem"
  
  attr_accessor :gift_wrap
  attr_accessor :used_coupon
  attr_accessor :used_promotion
  attr_accessor :freight
  attr_accessor :address
  attr_accessor :credits
  attr_accessor :gift
  
  #TODO: refactor this to include price as a parameter
  def add_item(variant, quantity=nil, gift_position=0, gift=false)
    #BLOCK ADD IF IS NOT GIFT AND HAS GIFT IN CART
    return nil if self.has_gift_items? && !gift

    quantity ||= Cart::DEFAULT_QUANTITY.to_i
    quantity = quantity.to_i
    
    return nil unless variant.available_for_quantity?(quantity)
    
    current_item = items.select { |item| item.variant == variant }.first
    if current_item
      current_item.update_attributes(:quantity => quantity)
    else
      #ACCESS PRODUCT IN PRICES TO ACCESS MASTER VARIANT
      
      retail_price = if gift
        variant.gift_price(gift_position)
      else
        variant.product.retail_price
      end
      
      current_item =  CartItem.new(:cart_id => id,
                                   :variant_id => variant.id,
                                   :quantity => quantity,
                                   :price => variant.product.price,
                                   :retail_price => retail_price,
                                   :discount_source => :legacy,
                                   :gift_position => gift_position,
                                   :gift => gift
                                   )
      items << current_item
    end
    
    current_item
  end

  def remove_item(variant)
    current_item = items.select { |item| item.variant == variant }.first
    current_item.destroy if current_item
  end
  
  def items_total
    items.sum(:quantity)
  end
  
  def gift_wrap?
    gift_wrap == "1" ? true : false
  end
  
  def clear
    items.destroy_all
  end
  
  def has_gift_items?
    items.where(:gift => true).count > 0
  end
  
  def total
    PriceModificator.new(self).final_price
  end
  
  def freight_price
    0
  end
  
  def coupon_discount
    PriceModificator.new(self).discounts[:coupon][:value]
  end
  
  def credits_discount
    PriceModificator.new(self).discounts[:credits][:value]
  end
  
  def promotion_discount
    PriceModificator.new(self).discounts[:promotion][:value]
  end
end