# -*- encoding : utf-8 -*-
class MinorPriceAdjustment < PromotionAction
  def calculate(cart_items, quantity)
    calculated_adjustments = []
    minor_price_items(cart_items, quantity.to_i).each do |item|
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
