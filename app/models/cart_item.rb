# -*- encoding : utf-8 -*-
class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :variant
  has_one :cart_item_adjustment, dependent: :destroy

  delegate :product, :to => :variant, :prefix => false
  delegate :name, :to => :variant, :prefix => false
  delegate :description, :to => :variant, :prefix => false
  delegate :thumb_picture, :to => :variant, :prefix => false
  delegate :color_name, :to => :variant, :prefix => false
  delegate :liquidation?, :to => :product

  after_create :create_adjustment, :notify
  after_update :notify
  after_destroy :notify
  attr_reader :discount_service

  def product_quantity
    deafult_quantity = [1]
    is_suggested_product? ? suggested_product_quantity : deafult_quantity
  end

  def price
    product.price
  end

  def retail_price(options={})
    olooklet_value = variant.product.retail_price == 0 ? price : variant.product.retail_price
    promotional_value = price - adjustment_value / quantity.to_f if has_adjustment?

    min_value_excluding_nil = [promotional_value, olooklet_value].compact.min
    min_value_excluding_nil || 0
  end

  def discount_service
    @discount_service ||= ProductDiscountService.new(product, cart: cart, coupon: cart.coupon, promotion: Promotion.select_promotion_for(cart))
  end

  def final_price
    discount_service.final_price
  end

  def is_suggested_product?
    product.id == Setting.checkout_suggested_product_id.to_i
  end

  def has_any_discount?
    price != retail_price
  end

  def adjustment_value
    adjustment = cart_item_adjustment ? cart_item_adjustment : create_adjustment
    adjustment.value
  end

  def has_adjustment?
    adjustment_value > 0
  end

  def should_apply?(adjust)
    without_liquidation? || is_adjust_greater?(adjust)
  end

  private

    def suggested_product_quantity
      Setting.quantity_for_sugested_product.to_a
    end

    def create_adjustment
      CartItemAdjustment.create(value: 0, cart_item: self, source: "")
    end

    def notify
      PromotionListener.update(self.cart)
    end

    def without_liquidation?
      !liquidation?
    end

    def is_adjust_greater?(adjust)
      liquidation? && (price - retail_price) < adjust
    end
end

