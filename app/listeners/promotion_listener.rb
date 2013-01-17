# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update cart
    reset_adjustments_for cart
    best_promotion = Promotion.select_promotion_for(cart)
    apply best_promotion, cart
  end

  def self.reset_adjustments_for cart
    cart.items.each { |item| item.cart_item_adjustment.update_attributes(value: 0, source: nil) }
  end

  private

    def self.apply promotion, cart
      return if promotion.nil?
      promotion.apply(cart) if promotion.should_apply_for?(cart)
    end

end
