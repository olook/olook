# -*- encoding : utf-8 -*-
class FirstBuy < PromotionRule

  def matches? attributes={}
    user = attributes[:user]
    return false if user.nil?

    return ! (user.has_purchased_orders? || DiscountExpirationCheckService.discount_expired?(user))
  end

end
