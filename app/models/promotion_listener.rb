# -*- encoding : utf-8 -*-
class PromotionListener

  def self.update attributes
    matched_promotions = []

    Promotion.active_and_not_expired(Date.current).each do |promotion|

      # TODO is the promotion valid and active ?

      matched_all_rules = promotion.promotion_rules.inject(true) do | match_result, rule | 
        match_result &&= rule.matches?(attributes)
      end
  
      matched_promotions << promotion if matched_all_rules
    end

    # TODO choose the best promotion for the user, and apply it
    matched_promotions.each { |promotion| promotion.apply(attributes[:cart]) }

    Rails.logger.info "Applied promotions: #{matched_promotions} for cart [#{attributes[:cart].id}]"

  end

end