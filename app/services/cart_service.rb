# -*- encoding : utf-8 -*-
class CartService
    
  attr_accessor :cart
  attr_accessor :gift_wrap
  attr_accessor :used_coupon
  attr_accessor :used_promotion
  attr_accessor :freight
  attr_accessor :credits
  

  def initialize(params)
    params.each_pair do |key, value|
      send(key.to_s+'=',value)
    end
  end

  def generate_order!(payment)
    raise ActiveRecord::RecordNotFound.new('A valid freight is required for generating an order.') if freight.nil?
    raise ActiveRecord::RecordNotFound.new('A valid user is required for generating an order.') if user.nil?

    order = Order.create!(
      :cart_id => self.id,
      :payment => payment,
      :credits => credits_discount,
      :user_id => user.id,
      :restricted => has_gift_items?,
      :gift_wrap => gift_wrap?
    )

    order.line_items = items.map do |item|
      LineItem.new( :variant_id => item.variant.id, :quantity => item.quantity, :price => item.price,
                    :retail_price => item.retail_price, :gift => item.gift)
    end

    order.freight = Freight.create(freight)

    # Creates UsedPromotion
    PromotionService.new(user, order).apply_promotion if promotion_discount > 0

    # Creates UsedCoupon
    CouponManager.new(order, price_modificator.discounts[:coupon][:code]).apply_coupon if coupon_discount > 0

    order.save
    order  
  end
  
  def gift_wrap?
    gift_wrap == "1" ? true : false
  end

  def total
    # price_modificator.final_price
    0
  end

  def freight_price
    price_modificator.increments[:freight][:value]
  end

  def freight_city
    ""
  end
  
  def freight_state
    ""
  end

  def coupon_discount
    #price_modificator.discounts[:coupon][:value]
    0
  end

  def credits_discount
    # price_modificator.discounts[:credits][:value]
    0
  end

  def promotion_discount
    #price_modificator.discounts[:promotion][:value]
    0
  end

  def price_modificator
    @modificator ||= PriceModificator.new(self)
  end  
  def subtotal
    price_modificator.original_price
  end
  
  def has_more_than_one_discount?
    false
  end
  
end