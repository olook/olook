module Promotions
  class PurchasesAmountStrategy
    attr_reader :user, :param

    def initialize param, user, order=nil
      @param = param
      @user = user
      @order = order
    end

    def matches?
      user.orders.purchased.size == param.to_i
    end
  end
end
