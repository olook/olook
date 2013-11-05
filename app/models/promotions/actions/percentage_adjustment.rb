# -*- encoding : utf-8 -*-
class PercentageAdjustment < PromotionAction
  filters[:param] = { desc: "Valor em % para ser descontado dos produtos", kind: 'integer' }
  private
  def calculate(cart_items, filters = {})
    percent = filters.delete('param')
    calculated_values = []
    filter_items(cart_items, filters).each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjustment = sub_total * BigDecimal("#{percent.to_i / 100.0}")
      calculated_values << {
        id: cart_item.id,
        product_id: item.product.id,
        adjustment: adjustment
      }
    end
    calculated_values
  end
end

