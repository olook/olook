# -*- encoding : utf-8 -*-
class PercentageAdjustment < PromotionAction

  protected

    def calculate(cart_items, percent)
      calculated_values = []
      cart_items.each do |cart_item|
        sub_total = cart_item.quantity * cart_item.price
        adjustment = sub_total * BigDecimal("#{percent.to_i / 100.0}")
        # TODO => put this small logic into super class (if should apply...)
        calculated_values << { id: cart_item.id, adjustment: adjustment } if cart_item.should_apply?(adjustment)
      end
      calculated_values
    end
end

