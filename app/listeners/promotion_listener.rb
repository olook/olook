# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update cart
    reset_adjustments_for cart
    # TODO[galeto] => these two methods could be merged into one (inside promotion class).
    promotions_to_apply = Promotion.matched_promotions_for cart
    best_promotion = Promotion.best_promotion_for(cart, promotions_to_apply)
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
