# -*- encoding : utf-8 -*-
class MinorPriceAdjustment < PromotionAction

  def apply(cart, parameter)
    calculate(cart, parameter).each do |item|
      item.cart_item_adjustment.update_attributes(value: item.price)
    end
  end

  def simulate(cart, parameter)
    cart.items.any? ? calculate(cart).sum(&:price) : 0
  end

  private
    def calculate(cart, parameter)
      free_items = cart.items.size / parameter
      cart.items.sort_by { |item| item.price }.first(free_items)
    end
end
