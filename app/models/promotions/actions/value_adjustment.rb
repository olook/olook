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
    cart_total = eligible_items.inject(0) {|total, item| total += item.variant.retail_price * item.quantity}

    eligible_items.sort! do |a,b|
      b.variant.price - b.variant.retail_price <=> a.variant.price - a.variant.retail_price
    end
    eligible_items.each do |item|
      adjustment = calculate_adjustment_value_for(value, cart_total, item.variant.retail_price * item.quantity)
      if _filters['full_price'] == '2'
        subtotal = (item.variant.retail_price * item.quantity)
        markdown_discount = ( item.variant.price - item.variant.retail_price ) * item.quantity
        if adjustment < markdown_discount
          adjustment = 0
          cart_total -= subtotal
        else
          adjustment = subtotal - (item.variant.price * item.quantity - adjustment)
        end
      end
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
