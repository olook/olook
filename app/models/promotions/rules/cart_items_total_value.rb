# -*- encoding : utf-8 -*-
class CartItemsTotalValue < PromotionRule

  def matches?(cart, parameter)
    items_value = cart.items.inject(0) {|total, i| total += i.price * i.quantity}
    items_value >= parameter
  end

end
