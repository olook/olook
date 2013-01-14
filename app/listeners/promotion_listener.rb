# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update cart
    reset_adjustments_for cart
    promotions_to_apply = matched_promotions_for cart

    if promotions_to_apply.any?
      best_promotion, total_promotion_discount = choose_best_promotion cart, promotions_to_apply
      best_promotion.apply cart if total_promotion_discount > cart.total_coupon_discount

      Rails.logger.info "Applied promotion: #{best_promotion} for cart [#{cart.id}]"
    end
  end

  def self.reset_adjustments_for cart
    cart.items.each { |item| item.cart_item_adjustment.update_attributes(value: 0, source: nil) }
  end

  private

    def self.matched_promotions_for cart 
      matched_promotions = []  
      Promotion.active_and_not_expired(Date.today).each do |promotion|

        # TODO is the promotion valid and active ?
        matched_all_rules = promotion.promotion_rules.inject(true) do | match_result, rule |
          match_result &&= rule.matches?(cart.user)
        end
        matched_promotions << promotion if matched_all_rules
      end  
      matched_promotions
    end

    def self.choose_best_promotion cart, promotions_to_apply

      promotions = {}

      promotions_to_apply.map do |promotion| 
        adjustments = promotion.calculate(cart).values 
        promotions[promotion] = adjustments.sum
      end    
      
      best_promotion = promotions.sort_by { |key, value| value }
      best_promotion = best_promotion.last

      promotion_to_apply = best_promotion[0]
      total_promotion_discount = best_promotion[1]
      [promotion_to_apply, total_promotion_discount]
    end


end
