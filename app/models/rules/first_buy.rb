# -*- encoding : utf-8 -*-
class FirstBuy < PromotionRule

  def matches? attributes={}
    user = attributes[:user]
    return true if user.nil?

    return ! user.has_purchased_orders?
  end

end
