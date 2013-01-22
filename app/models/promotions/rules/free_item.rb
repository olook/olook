# -*- encoding : utf-8 -*-
class FreeItem < PromotionRule

  def matches?(promotion, cart)
    cart.items.size % promotion.param_for(self) == 0
  end
end
