# -*- encoding : utf-8 -*-
class ValueAdjustment < PromotionAction
  filters[:param] = { desc: 'Valor em R$ a ser descontado da sacola', kind: 'currency' }
  private
  def calculate(cart_items, filters)
    value = filters.delete('param')
    calculated_values = []
    eligible_items = filter_items(cart_items, filters)
    adjustment = BigDecimal(value) / eligible_items.size
    eligible_items.each do |item|
      calculated_values << {
        id: item.id,
        product_id: item.product.id,
        adjustment: adjustment
      }
    end
    calculated_values
  end
end
