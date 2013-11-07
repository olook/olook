# -*- encoding : utf-8 -*-
class CartItemsTotalValue < PromotionRule

  def matches?(cart, parameter)
    cart.sub_total >= BigDecimal(parameter)
  end

end
