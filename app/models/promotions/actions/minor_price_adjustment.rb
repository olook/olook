# -*- encoding : utf-8 -*-
class MinorPriceAdjustment < PromotionAction
  filters[:param] = { desc: 'Quantos produtos ficarão de graça? (sempre pegamos os de menor valor primeiro)', kind: 'integer' }

  def name
    "Produto de graça (menor preço primeiro)"
  end

  def eg
    "Serve para fazer promoções leve 3 pague 2 por ex. Nesse caso adicione 1 como Quantos produtos ficarão de graça e o critério de Quantidade de produtos na sacola como 3"
  end

  def desc_value(filters)
    quantity = filters.delete('param').to_i
    "#{quantity} #{"produto".pluralize(quantity)} de graça"
  end

  def calculate(cart_items, filters)
    _filters = filters.dup
    quantity = _filters[ 'param' ]
    calculated_adjustments = []
    eligible_items = filter_items(cart_items, _filters)
    minor_price_items(eligible_items, quantity.to_i).each do |item|
      calculated_adjustments << {
        id: item.id,
        product_id: item.product.id,
        adjustment: item.retail_price
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
