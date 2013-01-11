# -*- encoding : utf-8 -*-
class PercentageAdjustment < PromotionAction

  #parameter :percent, :integer

  def apply(cart, percent)
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjust = sub_total * BigDecimal("#{percent.to_i / 100.0}")
      cart_item.cart_item_adjustment.update_attribute(:value, adjust)
    end
  end
end
