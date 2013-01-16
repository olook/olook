# -*- encoding : utf-8 -*-
class PercentageAdjustment < PromotionAction

  def apply(cart, percent)
    calculate(cart, percent).each do |item|
      cart.items.find(item[:id]).cart_item_adjustment.update_attributes(value: item[:adjust])
    end
  end

  def simulate(cart, percent)
    cart.items.any? ? calculate(cart, percent) : 0
  end

  private

  def calculate(cart, percent)
    calculated_values = []
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjust = sub_total * BigDecimal("#{percent.to_i / 100.0}")
      calculated_values << { id: cart_item.id, adjust: adjust } if cart_item.should_apply?(adjust)
    end
    calculated_values
  end
end

