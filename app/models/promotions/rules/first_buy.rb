# -*- encoding : utf-8 -*-
module Promo
  class FirstBuy < PromotionRule

    def matches? user
      return false if user.nil?

      return ! (user.has_purchased_orders? || DiscountExpirationCheckService.discount_expired?(user))
    end
  end
end
