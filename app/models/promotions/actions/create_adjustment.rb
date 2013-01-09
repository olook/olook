# -*- encoding : utf-8 -*-
class CreateAdjustment < PromotionAction
  def self.apply(cart, promotion)
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjust = sub_total * BigDecimal(promotion.action_parameter.param)
      cart_item.adjustment.update_attribute(:value, adjust)
    end
  end
end
