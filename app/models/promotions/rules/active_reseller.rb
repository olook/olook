# -*- encoding : utf-8 -*-
class ActiveReseller < PromotionRule

  def matches?(cart, parameter=nil)
    user = cart.user
    user.try(:reseller?) && user.try(:active?)
  end
end
