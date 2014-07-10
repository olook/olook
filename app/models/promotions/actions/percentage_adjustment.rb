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

  def calculate_value(value, filters)
    percent = filters[ 'param' ].to_f
    percent_rest = (1 - ( percent/100 ))
    percent_rest = 0 if percent_rest < 0
    value * percent_rest
  end

  def calculate(cart_items, filters = {})
    _filters = filters.dup
    percent = _filters[ 'param' ]
    calculated_values = []

    eligible_items = filter_items(cart_items, _filters)

    eligible_items.each do |cart_item|
      base_price = cart_item.variant.retail_price
      if _filters['full_price'] == '2'
        base_price = cart_item.variant.price
      end
      adjustment = calculate_adjustment(cart_item, base_price, percent)
      adjustment = 0 if adjustment < 0

      calculated_values << {
        id: cart_item.id,
        product_id: cart_item.product.id,
        adjustment: adjustment
      }
    end
    calculated_values
  end

  private

  def calculate_adjustment(cart_item, base_price, percent)
    sub_total = cart_item.quantity * base_price
    discounted_price = sub_total * BigDecimal("#{(100 - percent.to_f)/100}")
    cart_item.variant.retail_price - discounted_price
  end
end

