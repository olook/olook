# -*- encoding : utf-8 -*-
class CartItemsAmount < PromotionRule

  def matches?(promotion, cart)
    cart.items.size % self.param_for(promotion) == 0
  end
end
