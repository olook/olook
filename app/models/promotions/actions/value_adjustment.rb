# -*- encoding : utf-8 -*-
class ValueAdjustment < PromotionAction
  filters[:param] = { desc: 'Valor em R$ a ser descontado da sacola', kind: 'currency' }
  private
  def calculate(cart_items, value)
    calculated_values = []
    adjustment = BigDecimal(value) / cart_items.size
    cart_items.each do |item|
      calculated_values << {
        id: item.id,
        product_id: item.product.id,
        adjustment: adjustment
      }
    end
    calculated_values
  end
end
