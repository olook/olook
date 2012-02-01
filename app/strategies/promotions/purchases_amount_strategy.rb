module Promotions
  class PurchasesAmountStrategy
    attr_reader :user, :param
    NOT_PURCHASED_STATES = ["canceled", "reversed", "refunded"]

    def initialize param, user
      @param = param
      @user = user
    end

    def process
      user.orders.purchased.size == param.to_i
    end
  end
end
