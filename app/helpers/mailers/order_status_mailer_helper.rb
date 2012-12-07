# -*- encoding : utf-8 -*-
module Mailers::OrderStatusMailerHelper

  def used_20_percent_descount?
    if Promotions::PurchasesAmountStrategy.new("1", @order.user, @order).matches_20_percent_promotion?
       content_tag :p, "Você utilizou seu desconto de 20% neste pedido."
    end
  end
end
