# -*- encoding : utf-8 -*-
class ActiveReseller < PromotionRule

  def name
    "For uma revendedora avita"
  end

  def need_param
    false
  end

  def matches?(cart, parameter=nil)
    user = cart.user
    user.try(:reseller?) && user.try(:active?)
  end
end
