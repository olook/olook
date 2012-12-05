module Promotions
  class PurchasesAmountStrategy
    attr_reader :user, :param

    def initialize param, user, order=nil
      @param = param
      @user = user
      @order = order
    end

    def matches?
      return false unless user && user.created_at
      return false if DiscountExpirationCheckService.discount_expired?(user)

      user ? user.orders.purchased.size == param.to_i : 0 == param.to_i
    end
  end
end
