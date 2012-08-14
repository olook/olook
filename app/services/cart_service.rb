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
      self.send(key.to_s+'=',value)
    end
    
    self.credits ||= 0
  end
  
  def gift_wrap?
    gift_wrap == "1" ? true : false
  end
  
  def freight_price
    freight && freight.fetch(:price, 0) || 0
  end

  def freight_city
    freight && freight.fetch(:city, "") || ""
  end
  
  def freight_state
    freight && freight.fetch(:state, "") || ""
  end
  
  def item_price(item)
    get_retail_price_for_item(item).fetch(:price)
  end
  
  def item_retail_price(item)
    get_retail_price_for_item(item).fetch(:retail_price)
  end
    
  def item_promotion?(item)
    item_price(item) != item_retail_price(item)
  end
  
  def item_price_total(item)
    item_price(item) * item.quantity
  end

  def item_retail_price_total(item)
    item_retail_price(item) * item.quantity
  end
  
  def item_discount_percent(item)
    get_retail_price_for_item(item).fetch(:percent)
  end
  
  def item_discount_origin(item)
    get_retail_price_for_item(item).fetch(:origin)
  end
  
  def item_discount_origin_type(item)
    get_retail_price_for_item(item).fetch(:origin_type)
  end
  
  def item_discounts(item)
    get_retail_price_for_item(item).fetch(:discounts)
  end

  def item_has_more_than_one_discount?(item)
    item_discounts(item).size > 1
  end

  def subtotal(type = :retail_price)
    cart.items.inject(0) do |value, item|
      value += self.send("item_#{type}_total", item)
    end
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
  
  def is_minimum_payment?
    calculate_discounts.fetch(:is_minimum_payment)
  end
  
  def total_discount_by_type(type)
    total_value = 0
    total_value += total_coupon_discount if :coupon == type
    total_value += total_credits_discount if :credits == type
    
    cart.items.each do |item|
      if item_discount_origin_type(item) == type
        total_value += (item_price(item) - item_retail_price(item))
      end
    end
    
    total_value
  end
  
  def active_discounts
    discounts = cart.items.inject([]) do |discounts, item|
      discounts + item_discounts(item)
    end
    
    discounts.uniq
  end
  
  def has_more_than_one_discount?
    active_discounts.size > 1
  end
  
  def total
    total = subtotal(:retail_price)
    total += total_increase
    total -= total_discount
    
    total = Payment::MINIMUM_VALUE if total < Payment::MINIMUM_VALUE
    total
  end
  
  def generate_order!(payment)
    raise ActiveRecord::RecordNotFound.new('A valid cart is required for generating an order.') if cart.nil?
    raise ActiveRecord::RecordNotFound.new('A valid freight is required for generating an order.') if freight.nil?
    raise ActiveRecord::RecordNotFound.new('A valid user is required for generating an order.') if cart.user.nil?
    
    user = cart.user

    order = Order.create!(
      :cart_id => cart.id,
      :payment => payment,
      :credits => total_credits_discount,
      :user_id => user.id,
      :restricted => cart.has_gift_items?,
      :gift_wrap => gift_wrap?,
      :amount_discount => total_discount,
      :amount_increase => total_increase,
      :amount_paid => total,
      :subtotal => subtotal,
      :user_first_name => user.first_name,
      :user_last_name => user.last_name,
      :user_email => user.email,
      :user_cpf => user.cpf
    )

    order.line_items = cart.items.map do |item|
      LineItem.new( :variant_id => item.variant.id, :quantity => item.quantity, :price => item_price(item),
                    :retail_price => item_retail_price(item), :gift => item.gift)
    end

    order.freight = Freight.create(freight)

    # Creates UsedPromotion
    if promotion
      order.create_used_promotion(
        :promotion => promotion, 
        :discount_percent => promotion.discount_percent,
        :discount_value => total_discount_by_type(:promotion)
      ) 
    end

    # Creates UsedCoupon
    order.create_used_coupon(:coupon => coupon) if total_coupon_discount > 0

    order.save
    order  
  end
  
  private
  def get_retail_price_for_item(item)
    origin = ''
    percent = 0
    final_retail_price = item.variant.product.retail_price
    price = item.variant.product.price
    discounts = []
    origin_type = ''
    
    if price != final_retail_price
      percent =  (1 - (final_retail_price / price) )* 100
      origin = 'Olooklet: '+percent.ceil.to_s+'% de desconto'
      discounts << :olooklet
      origin_type = :olooklet
    end

    coupon = self.coupon
    if coupon && coupon.is_percentage?
      discounts << :coupon
      coupon_value = price - ((coupon.value * price) / 100)
      if coupon_value < final_retail_price
        percent = coupon.value
        final_retail_price = coupon_value
        origin = 'Desconto de '+percent.ceil.to_s+'% do cupom '+coupon.code
        origin_type = :coupon
      end
    end
        
    promotion = self.promotion
    if promotion
      discounts << :promotion
      promotion_value = price - ((price * promotion.discount_percent) / 100)
      if promotion_value < final_retail_price
        final_retail_price =  promotion_value
        percent = promotion.discount_percent
        origin = 'Desconto de '+percent.ceil.to_s+'% '+promotion.banner_label
        origin_type = :promotion
      end
    end

    if item.gift?
      final_retail_price = item.variant.gift_price(item.gift_position)
      percent =  (1 - (final_retail_price / price) ) * 100
      origin = 'Desconto de '+percent.ceil.to_s+'% para presente.'
      discounts  << :gift
      origin_type = :gift
    end
    
    {
      :origin       => origin, 
      :price        => price,
      :retail_price => final_retail_price,
      :percent      => percent,
      :discounts    => discounts,
      :origin_type  => origin_type
    }
  end
  
  def increment_from_gift_wrap
    gift_wrap? ? CartService.gift_wrap_price : 0
  end
  
  def minimum_value
    return 0 if freight_price > Payment::MINIMUM_VALUE
    Payment::MINIMUM_VALUE
  end
  
  def calculate_discounts
    discounts = []
    retail_value = self.subtotal(:retail_price) - minimum_value
    retail_value = 0 if retail_value < 0
    total_discount = 0
    
    coupon_value = self.coupon.value if self.coupon && !self.coupon.is_percentage?
    coupon_value ||= 0
    
    if coupon_value >= retail_value
      coupon_value = retail_value
    end
    
    retail_value -= coupon_value
    
    credits_value = self.credits
    credits_value ||= 0
    if credits_value >= retail_value
      credits_value = retail_value
    end
    
    retail_value -= credits_value
    
    discounts << :coupon if coupon_value > 0
    discounts << :credits if credits && credits > 0
    
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
