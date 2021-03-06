# -*- encoding : utf-8 -*-
class ActiveReseller < PromotionRule

  def name
    "For uma revendedora ativa"
  end

  def need_param
    false
  end

  def matches?(cart, parameter=nil)
    user = cart.try(:user)
    user.try(:reseller?) && user.try(:active?)
  end
end
