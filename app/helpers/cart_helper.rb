# -*- encoding : utf-8 -*-
module CartHelper

  def print_credit_message
    "(não podem ser utilizados em pedidos com desconto)" unless @cart.allow_credit_payment?
  end

  def total_user_credits
    return @user.current_credit if @cart.allow_credit_payment?
    @user.user_credits_for(:redeem).total
  end

end