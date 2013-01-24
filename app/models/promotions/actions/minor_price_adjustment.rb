# -*- encoding : utf-8 -*-
class MinorPriceAdjustment < PromotionAction

  def apply(cart, quantity)
    calculate(cart, quantity).each do |hash|
      item = hash[:item]
      adjustment = hash[:adjustment]
      item.cart_item_adjustment.update_attributes(value: adjustment)
    end
  end

  def simulate(cart, quantity)
    cart.items.any? ? calculate(cart, quantity).map{|hash| hash[:adjustment]}.reduce(:+) : 0
  end

  private
    def minor_price_items(cart, quantity)
      sorted_cart_items = cart.items.sort_by { |cart_item| cart_item.price }
      sorted_cart_items.first(quantity)
    end


    def calculate(cart, quantity)
      calculated_adjustments = []
      minor_price_items(cart, quantity).each do |item|
        calculated_adjustments << {item: item, adjustment: item.price}
      end
      calculated_adjustments
    end
end
