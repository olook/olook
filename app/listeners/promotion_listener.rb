# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update cart
    reset_adjustments_for cart
    promotions_to_apply = Promotion.matched_promotions_for cart
    promotion = Promotion.best_promotion_for(cart, promotions_to_apply)
    promotion.apply(cart) if promotion && promotion.should_apply_for?(cart)
  end

  def self.reset_adjustments_for cart
    cart.items.each { |item| item.cart_item_adjustment.update_attributes(value: 0, source: nil) }
  end
end
