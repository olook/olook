# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update cart
    reset_adjustments_for cart
    promotions_to_apply = matched_promotions_for cart
    apply_promotions(promotions_to_apply, cart)
  end

  def self.reset_adjustments_for cart
    cart.items.each { |item| item.cart_item_adjustment.update_attributes(value: 0, source: nil) }
  end

  private

    def self.matched_promotions_for cart
      matched_promotions(cart)
    end

    def self.choose_best_promotion cart, promotions_to_apply
      best_promotion = calculate(promotions_to_apply, cart).sort_by { |key, value| value }.last
      [best_promotion[:promotion], total_promotion_discount = best_promotion[:total_discount]]
    end

    def self.active_promotions
      Promotion.active_and_not_expired(Date.today)
    end

    def self.matched_promotions(cart)
      promotions = []
      active_promotions.each do |promotion|
       matched_all_rules = promotion.promotion_rules.inject(true) do | match_result, rule |
          match_result &&= rule.matches?(cart.user)
        end
        promotions << promotion if matched_all_rules
      end
      promotions
    end

    def self.calculate(promotions_to_apply, cart)
      promotions = []
      promotions_to_apply.map do |promotion|
        promotions << {promotion: promotion, total_discount: promotion.simulate(cart).map {|item| item[:adjust] }.reduce(:+)}
      end
      promotions
    end

    def self.apply_promotions(promotions_to_apply = [], cart)
      if promotions_to_apply.any? && cart.items.any?
        best_promotion, total_promotion_discount = choose_best_promotion cart, promotions_to_apply
        best_promotion.apply cart if total_promotion_discount > cart.total_coupon_discount

        Rails.logger.info "Applied promotion: #{best_promotion} for cart [#{cart.id}]"
      end
    end

end
