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
  
  def price_total
    price * quantity
  end

  def retail_price_total
    retail_price * quantity
  end
  
  def discount_percent
    get_retail_price.fetch(:percent)
  end
  
  def discount_origin
    get_retail_price.fetch(:origin)
  end
  
  def price
    get_retail_price.fetch(:price)
  end
  
  def retail_price
    get_retail_price.fetch(:retail_price)
  end
  
  def has_more_than_one_discount?
    get_retail_price.fetch(:discounts).size > 1
  end

  def discounts
    get_retail_price.fetch(:discounts)
  end
  
  private
  def get_retail_price
    origin = ''
    percent = 0
    final_retail_price = self.variant.product.retail_price
    price = self.variant.product.price
    discounts = []
    
    if price != final_retail_price
      percent =  (1 - (final_retail_price / price) )* 100
      origin = 'Olooklet: '+percent.ceil.to_s+'% de desconto'
      discounts << :olooklet
    end

    coupon = cart.coupon
    if coupon && coupon.is_percentage?
      coupon_value = price - ((coupon.value * price) / 100)
      if coupon_value < final_retail_price
        percent = coupon.value
        final_retail_price = coupon_value
        origin = 'Desconto de '+percent.ceil.to_s+'% do cupom '+coupon.code
        discounts << :coupon_percentage
      end
    end

    promotion = cart.promotion
    if promotion
      promotion_value = price - ((price * promotion.discount_percent) / 100)
      if promotion_value < final_retail_price
        final_retail_price =  promotion_value
        percent = promotion.discount_percent
        origin = 'Desconto de '+percent.ceil.to_s+'% '+promotion.banner_label
        discounts << :promotion
      end
    end

    if self.gift?
      final_retail_price = self.variant.gift_price(self.gift_position)
      percent =  (1 - (final_retail_price / price) ) * 100
      origin = 'Desconto de '+percent.ceil.to_s+'% para presente.'
      discounts  = [:gift]
    end

    {
      :origin       => origin, 
      :price        => price,
      :retail_price => final_retail_price,
      :percent      => percent,
      :discounts    => discounts
    }
  end

end
