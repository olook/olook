# -*- encoding : utf-8 -*-
class ActiveReseller < PromotionRule

  def eg
    "Somente Revendedor Ativo pode usar esse desconto"
  end

  def label_text
    "Deixe vazio para esta regra"
  end

  def matches?(cart, parameter=nil)
    user = cart.user
    user.try(:reseller?) && user.try(:active?)
  end
end
