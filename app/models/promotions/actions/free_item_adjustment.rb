# -*- encoding : utf-8 -*-
class FreeItemAdjustment < PromotionAction

  def apply(cart)
    calculate(cart).each do |item|
      item.cart_item_adjustment.update_attributes(value: item.retail_price)
    end
  end

  def simulate(cart)
    cart.items.any? ? calculate(cart).sum(&:price) : 0
  end

  private
    def calculate(cart)
      free_items = cart.items.size / 3 #TODO use promotion parameter
      cart.items.sort_by { |item| item.price }.first(free_items)
    end
end
