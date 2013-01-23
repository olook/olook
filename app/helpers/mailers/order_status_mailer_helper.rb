# -*- encoding : utf-8 -*-
module Mailers::OrderStatusMailerHelper

  def used_20_percent_descount?
    # Ugly stuff, but we are ripping off this promotion anyway
    promotion = OpenStruct.new(:param => "1")
    if Promotions::PurchasesAmountStrategy.new(promotion, @order.user, @order).matches_20_percent_promotion?
       content_tag :p, "Você utilizou seu desconto de 20% neste pedido."
    end
  end
end
