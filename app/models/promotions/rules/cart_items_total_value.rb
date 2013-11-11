# -*- encoding : utf-8 -*-
class CartItemsTotalValue < PromotionRule

  def name
    'O valor total dos itens for...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter)
    cart.sub_total >= BigDecimal(parameter)
  end

end
