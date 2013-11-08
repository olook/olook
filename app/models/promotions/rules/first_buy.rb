# -*- encoding : utf-8 -*-
class FirstBuy < PromotionRule

  def eg
    "Somente usuários que nunca compraram tem direito ao desconto"
  end

  def label_text
    "Deixe vazio para essa regra"
  end

  def matches?(cart, parameter=nil)
    user = cart.user
    return true if user.nil?

    discount_expired = DiscountExpirationCheckService.discount_expired?(user)

    return !user.has_purchased_orders? && !discount_expired
  end
end
