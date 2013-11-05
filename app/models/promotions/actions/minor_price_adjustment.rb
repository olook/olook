# -*- encoding : utf-8 -*-
class MinorPriceAdjustment < PromotionAction
  filters[:param] = { desc: 'Quantidade de produtos diferentes de menor valor que ficarão de graça', kind: 'integer' }

  def name
    "Produto de menor preço de graça"
  end

  def desc_value(filters)
    quantity = filters.delete('param').to_i
    "#{quantity} #{"produto".pluralize(quantity)} de graça"
  end
  def calculate(cart_items, filters)
    _filters = filters.dup
    quantity = _filters.delete('param')
    calculated_adjustments = []
    eligible_items = filter_items(cart_items, _filters)
    minor_price_items(eligible_items, quantity.to_i).each do |item|
      calculated_adjustments << {
        id: item.id,
        product_id: item.product.id,
        adjustment: item.price
      }
    end
    calculated_adjustments
  end

  private
  def minor_price_items(cart_items, quantity)
    sorted_cart_items = cart_items.sort_by { |cart_item| cart_item.retail_price }
    sorted_cart_items.first(quantity)
  end
end
