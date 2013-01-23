# -*- encoding : utf-8 -*-
class CartItemsAmount < PromotionRule

  def matches?(promotion, cart)
    quantity_of_items(cart) % promotion.param_for(self) == 0
  end

  private
    def quantity_of_items cart
      cart.items.inject(0) { |amount, item| amount += item.quantity }
    end
end
