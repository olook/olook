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
    "R$ #{value.to_i}"
  end

  def calculate(cart_items, filters)
    _filters = filters.dup
    value = BigDecimal(_filters['param'])
    calculated_values = []
    eligible_items = filter_items(cart_items, _filters)
    if _filters['full_price'] == '2'
      if !eligible_items.find { |item| item.product.retail_price == item.product.price }
        markdown_discount = eligible_items.inject(0) { |sum, item| sum + item.product.price - item.retail_price }
        eligible_items.reject! { |item| item.product.price != item.product.retail_price } if markdown_discount > value
      end
    end
    
    cart_total = eligible_items.inject(0) {|total, item| total = item.retail_price * item.quantity}

    eligible_items.each do |item|
      adjustment = calculate_adjustment_value_for(value, cart_total, item.retail_price * item.quantity)
      calculated_values << {
        id: item.id,
        product_id: item.product.id,
        adjustment: adjustment
      }
    end
    calculated_values
  end

  private
    def calculate_adjustment_value_for value, cart_total, current_item_value=0
      calculated_adjustment = value / cart_total * current_item_value
      [calculated_adjustment.round(2), current_item_value].min
    end
end
