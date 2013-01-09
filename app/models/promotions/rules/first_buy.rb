# -*- encoding : utf-8 -*-
class FirstBuy < PromotionRule

  def matches? user
    return false if user.nil?

    discount_expired = DiscountExpirationCheckService.discount_expired?(user)

    return !user.has_purchased_orders? && !discount_expired
  end
end
