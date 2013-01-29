# -*- encoding : utf-8 -*-
class ValueAdjustment < PromotionAction
  private
    def calculate(cart_items, value)
      calculated_values = []
      adjustment = value / cart_items.size
      cart_items.each do |item|
        calculated_values << { id: item.id, adjustment: adjustment }
      end
      calculated_values
    end
end
