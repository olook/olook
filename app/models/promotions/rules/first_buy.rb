# -*- encoding : utf-8 -*-
class FirstBuy < PromotionRule

  def name
    'Fizer a primeira compra'
  end

  def need_param
    false
  end

  def matches?(cart, parameter=nil)
    user = cart.user
    return true if user.nil?

    discount_expired = DiscountExpirationCheckService.discount_expired?(user)

    return !user.has_purchased_orders? && !discount_expired
  end
end
