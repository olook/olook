# -*- encoding : utf-8 -*-

class CreateAdjustment < PromotionAction
  def self.apply(cart, promotion)
    binding.pry
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjust = sub_total * BigDecimal(promotion.param)
      cart_item.adjustment.update_attributes(:value, adjust)
    end
  end
end
