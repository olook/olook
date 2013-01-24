# -*- encoding : utf-8 -*-
class CartItemsAmount < PromotionRule

  def matches?(cart, promotion)
    cart.items.sum(&:quantity) / self.param_for(promotion).to_i > 0
  end
end
