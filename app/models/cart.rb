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

  #TODO: refactor this to include price as a parameter
  def add_item(variant, quantity=nil, gift_position=0, gift_sell=false)
    #BLOCK ADD IF IS NOT GIFT AND HAS GIFT IN CART
    return nil if self.has_gift_items? && !gift_sell

    quantity ||= Cart::DEFAULT_QUANTITY.to_i
    quantity = quantity.to_i

    return nil unless variant.available_for_quantity?(quantity)

    current_item = items.select { |item| item.variant == variant }.first
    if current_item
      current_item.update_attributes(:quantity => quantity)
    else
      #ACCESS PRODUCT IN PRICES TO ACCESS MASTER VARIANT
      retail_price = if gift_sell
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
                                   :gift => gift_sell
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
    price_modificator.final_price
  end

  def freight_price
    0
  end

  def coupon_discount
    price_modificator.discounts[:coupon][:value]
  end

  def credits_discount
    price_modificator.discounts[:credits][:value]
  end

  def promotion_discount
    price_modificator.discounts[:promotion][:value]
  end

  def price_modificator
    @modificator ||= PriceModificator.new(self)
  end

  def generate_order(payment)
    raise ActiveRecord::RecordNotFound.new('A valid freight is required for generating an order.') if freight.nil?
    raise ActiveRecord::RecordNotFound.new('A valid user is required for generating an order.') if user.nil?

    order = Order.create!(
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

    order.freight = Freight.create(freight.attributes)

    # Creates UsedPromotion
    PromotionService.new(user, order).apply_promotion if promotion_discount > 0

    # Creates UsedCoupon
    CouponManager.new(user, price_modificator.discounts[:coupon][:code]).apply_coupon if coupon_discount > 0

    order.save
    order
  end
end
