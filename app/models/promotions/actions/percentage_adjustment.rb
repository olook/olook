# -*- encoding : utf-8 -*-
class PercentageAdjustment < PromotionAction
  filters[:param] = { desc: "Valor em % para ser descontado dos produtos", kind: 'integer' }

  def name
    "Desconto em % do valor do produto"
  end

  def eg
    "Da o desconto de porcentagem no valor dos produtos"
  end

  def desc_value(filters)
    percent = filters.delete('param')
    "#{'%d' % percent.to_i }%"
  end

  private
  def calculate(cart_items, filters = {})
    _filters = filters.dup
    percent = _filters.delete('param')
    calculated_values = []
    filter_items(cart_items, _filters).each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjustment = sub_total * BigDecimal("#{percent.to_i / 100.0}")
      calculated_values << {
        id: cart_item.id,
        product_id: cart_item.product.id,
        adjustment: adjustment
      }
    end
    calculated_values
  end
end

