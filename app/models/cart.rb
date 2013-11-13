# -*- encoding : utf-8 -*-
class Cart < ActiveRecord::Base
  DEFAULT_QUANTITY = 1

  belongs_to :user
  belongs_to :coupon
  belongs_to :address
  has_many :orders
  has_many :items, :class_name => "CartItem", :dependent => :destroy

  attr_accessor :coupon_code

  validates_with CouponValidator, :attributes => [:coupon_code]

  before_validation :update_coupon
  after_update :notify_listener

  def allow_credit_payment?
    has_empty_adjustments? && has_any_full_price_item? && self.sub_total >= 100
  end

  def add_variants(variant_numbers)
    variants = Variant.where("number in (?)", variant_numbers)
    variants.each { |v| add_item(v) }
  end

  def add_item(variant, quantity=nil, gift_position=0, gift=false)
    #BLOCK ADD IF IS NOT GIFT AND HAS GIFT IN CART
    return nil if self.has_gift_items? && !gift

    quantity = quantity.to_i == 0 ? Cart::DEFAULT_QUANTITY : quantity.to_i
   
    return nil unless variant.available_for_quantity?(quantity)

    current_item = items.select { |item| item.variant == variant }.first
    if current_item
      current_item.update_attributes(:quantity => quantity)
    else
      current_item =  CartItem.new(:cart_id => id,
                                   :variant_id => variant.id,
                                   :quantity => quantity,
                                   :gift_position => gift_position,
                                   :gift => gift
                                   )
      items << current_item
    end

    current_item
  end

  def items_total
   items.sum(:quantity)
  end

  def clear
    items.destroy_all
  end

  def has_gift_items?
    items.where(:gift => true).count > 0
  end

  def remove_unavailable_items
    unavailable_items = []
    items.each do |li|
      variant = Variant.lock("FOR UPDATE").find(li.variant.id)
      unavailable_items << li unless variant.available_for_quantity? li.quantity
    end
    size_items = unavailable_items.size
    unavailable_items.each {|item| item.destroy}
    size_items
  end

  def total_promotion_discount
    items.inject(0) {|sum, item| /Promotion:/ =~ item.cart_item_adjustment.source ? sum + item.adjustment_value : 0 }
  end

  def total_liquidation_discount(options={})
    items.inject(0) do |sum, item|
      liquidation_discount = item.adjustment_value > 0 ? 0 : item.price - item.retail_price(options)
      sum + liquidation_discount
    end
  end

  def total_coupon_discount
    items.inject(0) {|sum, item| /Coupon:/ =~ item.cart_item_adjustment.source ? sum + item.adjustment_value : 0 }
  end

  def total_price
    items.inject(0) { |total, item| total += item.quantity * item.price }
  end

  def sub_total
    items.inject(0) do |total, item|
      total += (item.quantity * item.retail_price)
    end
  end

  def remove_coupon!
    self.coupon_id = nil
    self.coupon_code = nil
    self.save!
    self.reload
  end

  # CONSIDER to change this method name
  def increment_from_gift_wrap
    gift_wrap ? CartService.gift_wrap_price : 0
  end

  def free_gift_wrap?
    coupon_code = coupon.try(:code)
    Setting.valentines_day_coupon_code == (coupon_code)
  end

  def has_appliable_percentage_coupon?
    coupon && coupon.is_percentage? && items.select{|item| coupon.apply_discount_to?(item.product)}.any?
  end

  def has_coupon?
    coupon.present? && (!coupon.is_percentage? || has_appliable_percentage_coupon?)
  end

  private

    def update_coupon
      if self.coupon_code == ''
        self.coupon_id = nil
        self.coupon_code = nil
      end
      if self.coupon_id
        self.coupon_code = self.coupon.code
      elsif self.coupon_code
        _coupon = Coupon.find_by_code(self.coupon_code)
        self.coupon = _coupon if _coupon
        self.gift_wrap = true if free_gift_wrap?
      end
    end

    def notify_listener
      PromotionListener.update(self)
    end

    def has_any_full_price_item?
      items.select { |item| item.price == item.retail_price }.any?
    end

    def has_empty_adjustments?
      items.select { |item| item.has_adjustment? }.empty?
    end

end
