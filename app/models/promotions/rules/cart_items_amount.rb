# -*- encoding : utf-8 -*-
class CartItemsAmount < PromotionRule

  def name
    "A quantidade de itens na sacola for..."
  end

  def need_param
    true
  end

  def matches?(cart, parameter)
    items_amount = cart.items.inject(0) {|total, i| total += i.quantity}
    items_amount / parameter.to_i > 0
  end

end
