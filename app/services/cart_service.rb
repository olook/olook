# -*- encoding : utf-8 -*-
class CartService
  attr_accessor :cart
  attr_accessor :gift_wrap
  attr_accessor :coupon
  attr_accessor :promotion
  attr_accessor :freight
  attr_accessor :credits

  def self.gift_wrap_price
    YAML::load_file(Rails.root.to_s + '/config/gifts.yml')["values"][0]
  end

  def initialize(params)
    params.each_pair do |key, value|
      send(key.to_s+'=',value)
    end
    
    credits ||= 0
    freight ||= {}
    
  end

  def generate_order!(payment)
    raise ActiveRecord::RecordNotFound.new('A valid freight is required for generating an order.') if freight.nil?
    raise ActiveRecord::RecordNotFound.new('A valid user is required for generating an order.') if cart.user.nil?

    order = Order.create!(
      :cart_id => cart.id,
      :payment => payment,
      :credits => total_credits_discount,
      :user_id => cart.user.id,
      :restricted => cart.has_gift_items?,
      :gift_wrap => gift_wrap?,
      :amount_discount => total_discount,
      :amount_increase => total_increase,
      :amount_paid => total,
      :subtotal => subtotal
    )

    order.line_items = cart.items.map do |item|
      LineItem.new( :variant_id => item.variant.id, :quantity => item.quantity, :price => item_price(item),
                    :retail_price => item_retail_price(item), :gift => item.gift)
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
  
  def freight_price
    freight.fetch(:price, 0)
  end

  def freight_city
    freight.fetch(:city, "")
  end
  
  def freight_state
    freight.fetch(:state, "")
  end
  
  def total_increase
    increase = 0
    increase += increment_from_gift_wrap
    increase += freight_price
    increase
  end

  def total_coupon_discount
    calculate_discounts.fetch(:total_coupon)
  end
  
  def total_credits_discount
    calculate_discounts.fetch(:total_credits)
  end
  
  def total_discount
    calculate_discounts.fetch(:total_discount)
  end
  
  def subtotal(type = :retail_price)
    cart.items.inject(0) do |value, item|
      value += item.send("#{type}_total")
    end
  end
  
  def has_more_than_one_discount?
    discounts = cart.items.inject([]) do |discounts, item|
      discounts << item.discounts
    end
    
    discounts << calculate_discounts.fetch(:discounts)
    
    discounts.uniq.size > 1
  end
  
  def is_minimum_payment?
    calculate_discounts.fetch(:is_minimum_payment)
  end
  
  def total
    total = subtotal(:retail_price)
    total += total_increase
    total -= total_discount
    total
  end
  
  private
  def increment_from_gift_wrap
    gift_wrap? ? self.gift_wrap_price : 0
  end
  
  def minimum_value
    return 0 if freight_price > Payment::MINIMUM_VALUE
    Payment::MINIMUM_VALUE
  end
  
  def calculate_discounts
    discounts = []
    retail_value = self.subtotal(:retail_price) - self.minimum_value
    total_discount = 0
    
    coupon_value = self.coupon.value if self.coupon && !self.coupon.is_percentage?
    coupon_value ||= 0
    
    if coupon_value >= retail_value
      coupon_value = retail_value
    end
    
    retail_value -= coupon_value
    
    credits_value = self.credits
    if credits_value >= retail_value
      credits_value = retail_value
    end
    
    retail_value -= credits_value
        
    discounts << :coupon if coupon_value > 0
    discounts << :credits if credits > 0
    
    { 
      :discounts          => discounts,
      :credits_limit      => (credits_value != credits),
      :is_minimum_payment => (retail_value <= 0),
      :total_discount     => (coupon_value + credits_value),
      :total_coupon       => coupon_value,
      :total_credits      => credits_value
    }
  end
end
