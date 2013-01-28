# -*- encoding : utf-8 -*-
class CartItemsTotalValue < PromotionRule

  def matches?(cart, parameter)
    cart.total_price >= parameter
  end

end
