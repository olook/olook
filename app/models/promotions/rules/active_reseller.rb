# -*- encoding : utf-8 -*-
class ActiveReseller < PromotionRule

  def matches?(cart, parameter=nil)
    user = cart.user
    user.reseller? && user.active?
  end
end
