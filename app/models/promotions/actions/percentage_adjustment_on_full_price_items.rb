# -*- encoding : utf-8 -*-
class PercentageAdjustmentOnFullPriceItems < PromotionAction

    def calculate(cart_items, percent)
      calculated_values = []
      cart_items.each do |cart_item|
        next if cart_item.promotion? 
        calculated_values << calculate_cart_item(cart_item,percent)
      end
      calculated_values
    end

    def calculate_cart_item(cart_item,percent)
      sub_total = cart_item.quantity * cart_item.price
      adjustment = sub_total * BigDecimal("#{percent.to_i / 100.0}")
      { id: cart_item.id, adjustment: adjustment }
    end
end
