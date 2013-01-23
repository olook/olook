# -*- encoding : utf-8 -*-
class FirstBuy < PromotionRule

  def matches? user
    return true if user.nil?

    discount_expired = DiscountExpirationCheckService.discount_expired?(user)

    return !user.has_purchased_orders? && !discount_expired
  end
end
