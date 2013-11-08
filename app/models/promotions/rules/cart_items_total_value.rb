# -*- encoding : utf-8 -*-
class CartItemsTotalValue < PromotionRule

  def eg
    "É preciso ter uma somatória de valores no carrinho para ativar o desconto"
  end

  def label_text
    "Valor mínimo do carrinho"
  end

  def matches?(cart, parameter)
    cart.sub_total >= BigDecimal(parameter)
  end

end
