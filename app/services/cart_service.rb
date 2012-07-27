# -*- encoding : utf-8 -*-
class CartService

  attr_accessor :cart
  attr_accessor :gift_wrap
  attr_accessor :coupon
  attr_accessor :promotion
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
    0
  end

  def freight_price
    0
  end

  def freight_city
    ""
  end
  
  def freight_state
    ""
  end

  def coupon_discount
    0
  end

  #CALCULA O CREDITOS PARA O CART
  def credits_discount
    0
  end
  
  #CALCULA PROMOTION
  def promotion_discount
    0
  end

  def subtotal
    0
  end
  
  def has_more_than_one_discount?
    false
  end
  
  def is_minimum_payment?
    false
  end
  
  def item_discount_percent(item)
    get_retail_price_for_line_item(item).fetch(:percent)
  end
  
  def get_discount_origin(item)
    get_retail_price_for_line_item(item).fetch(:origin)
  end
  
  def item_promotion?(item)
    item_price(item) != item_retail_price(item)
  end
  
  def item_price(item)
    get_retail_price_for_line_item(item).fetch(:price)
  end
  
  def item_retail_price(item)
    get_retail_price_for_line_item(item).fetch(:retail_price)
  end
  
  def get_retail_price_for_line_item(item)
    origin = ''
    percent = 0
    final_retail_price = item.variant.product.retail_price

    if item.variant.product.price != final_retail_price
      percent =  (1 - (final_retail_price / item.variant.product.price) )* 100
      origin = 'Olooklet: '+percent.ceil.to_s+'% de desconto'
    end

    if coupon && coupon.is_percentage?
      coupon_value = item.variant.product.price - ((coupon.value * item.variant.product.price) / 100)
      if coupon_value < final_retail_price
        percent = coupon.value
        final_retail_price = coupon_value
        origin = 'Desconto de '+percent.ceil.to_s+'% do cupom '+coupon.code
      end
    end

    if promotion && (!coupon || (coupon && coupon.is_percentage?))
      promotion_value = item.variant.product.price - ((item.variant.product.price * promotion.promotion.discount_percent) / 100)
      if promotion_value < final_retail_price
        final_retail_price =  promotion_value
        percent = promotion.discount_percent
        origin = 'Desconto de '+percent.ceil.to_s+'% '+promotion.banner_label
      end
    end

    # if restricted?
    #   final_retail_price = item.retail_price
    #   percent =  (1 - (final_retail_price / item.price) )* 100
    #   origin = 'Desconto de '+percent.ceil.to_s+'% para presente.'
    # end
    {
      :origin       => origin, 
      :price        => item.variant.product.price,
      :retail_price => final_retail_price,
      :percent      => percent
    }
  end
end