# -*- encoding : utf-8 -*-
class PercentageAdjustment < PromotionAction

  #parameter :percent, :integer

  def apply(cart, promotion)
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      percent = params(promotion).to_i
      adjust = sub_total * BigDecimal("#{percent / 100.0}")
      cart_item.adjustment.update_attribute(:value, adjust)
    end
  end
end
