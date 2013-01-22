# -*- encoding : utf-8 -*-
class FreeItemAdjustment < PromotionAction

  def simulate(cart)
    cart.items.any? ? calculate(cart) : 0
  end

  private
    def calculate(cart)
      cart.items.sort_by { |item| item.price }.first.price
    end
end
