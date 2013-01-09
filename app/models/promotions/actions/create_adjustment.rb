# -*- encoding : utf-8 -*-

class CreateAdjustment < PromotionAction
  def self.apply(cart, promotion)
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      # TODO get params of rules params
      #adjust = sub_total * BigDecimal(promotion.rules_parameters.first.params)
      adjust = sub_total * BigDecimal("0.2")
      cart_item.adjustment.update_attribute(:value, adjust)
    end
  end
end
