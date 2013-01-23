# -*- encoding : utf-8 -*-
class CartItemsAmount < PromotionRule

  def matches?(cart, promotion)
    cart.items.size % self.param_for(promotion) == 0
  end
end
