# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update attributes
    cart = attributes[:cart]

    # TODO after merge with restful_checkout, we can user cart.coupon to check if the cart 
    # has coupon and avoid giving promotion discount

    matched_promotions = []

    Promotion.active_and_not_expired(Date.current).each do |promotion|

      # TODO is the promotion valid and active ?

      matched_all_rules = promotion.promotion_rules.inject(true) do | match_result, rule | 
        match_result &&= rule.matches?(attributes)
      end
  
      matched_promotions << promotion if matched_all_rules
    end

    # TODO choose the best promotion for the user, and apply it
    matched_promotions.each { |promotion| promotion.apply(cart) }

    Rails.logger.info "Applied promotions: #{matched_promotions} for cart [#{cart.id}]"

  end

end