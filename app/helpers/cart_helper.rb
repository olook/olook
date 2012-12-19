# -*- encoding : utf-8 -*-
module CartHelper

  def print_credit_message
    "(não podem ser utilizados em pedidos com desconto)" unless @cart_service.allow_credit_payment?
  end

  def total_user_credits
    return @user.current_credit if @cart_service.allow_credit_payment?
    @user.user_credits_for(:redeem).total
  end

  def promotion_discount(item)
    if @cart_service.item_retail_price_total(item) == 0
      "Este é grátis"
    else
      number_to_percentage(@cart_service.item_discount_percent(item), :precision => 0)
    end
  end

end