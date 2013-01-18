# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update cart
    reset_adjustments_for cart
    apply_best_promotion_for cart
  end

  def self.should_apply_coupon?(cart, coupon)
    best_promotion = Promotion.select_promotion_for(cart)

    best_promotion ?  coupon.value > best_promotion.total_discount_for(cart) : true
  end

  private

    def self.reset_adjustments_for cart
      cart.items.each { |item| item.cart_item_adjustment.update_attributes(value: 0, source: nil) }
    end

    def self.apply_best_promotion_for cart
      best_promotion = Promotion.select_promotion_for(cart)
      best_promotion.apply(cart) if best_promotion
    end

end
