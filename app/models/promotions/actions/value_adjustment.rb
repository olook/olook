# -*- encoding : utf-8 -*-
class ValueAdjustment < PromotionAction
  filters[:param] = { desc: 'Valor em R$ a ser descontado da sacola', kind: 'currency' }

  def name
    "Desconto em R$ na sacola"
  end

  def eg
    "Desconto de valor absoluto na sacola. Ex. R$ 30 independente do valor dos produtos adicionados."
  end

  def desc_value(filters, opts={})
    value = filters.delete('param')
    "R$#{value.to_i}"
  end
  private
  def calculate(cart_items, filters)
    _filters = filters
    value = _filters.delete('param')
    calculated_values = []
    eligible_items = filter_items(cart_items, _filters)
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
