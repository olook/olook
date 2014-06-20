# -*- encoding : utf-8 -*-
class CartItemsTotalValue < PromotionRule

  def name
    'O valor total dos itens for...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter)
    return false unless cart
    cart.sub_total >= BigDecimal(parameter)
  end

end
