module Promotions
  class PurchasesAmountStrategy
    attr_reader :user, :param

    def initialize param, user, order=nil
      @param = param
      @user = user
      @order = order
    end

    def matches?
      if user
        user.orders.paid.size == param.to_i
      else
        0 == param.to_i
      end
    end
  end
end
