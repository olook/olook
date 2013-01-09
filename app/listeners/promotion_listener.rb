# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update cart

    # TODO after merge with restful_checkout, we can user cart.coupon to check if the cart
    # has coupon and avoid giving promotion discount

    matched_promotions = []

    Promotion.active_and_not_expired(Date.today).each do |promotion|

      # TODO is the promotion valid and active ?
      matched_all_rules = promotion.promotion_rules.inject(true) do | match_result, rule |
        match_result &&= rule.matches?(cart.user)
      end

      matched_promotions << promotion if matched_all_rules
    end

    # set all adjustment to zero 
    reset_adjustments_for cart

    # TODO choose the best promotion for the user, and apply it
    # Use a simulate instead rollbacking the transaction
    Cart.transaction do
      matched_promotions.each { |promotion| promotion.apply(cart) }

      if cart.total_promotion_discount < cart.total_coupon_discount
        reset_adjustments
      end

    end

    Rails.logger.info "Applied promotions: #{matched_promotions} for cart [#{cart.id}]"

  end

  def self.reset_adjustments_for cart
    cart.items.each { |item| item.adjustment.update_attributes(:value => 0, :source => nil) }
  end

end
