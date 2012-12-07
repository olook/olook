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
        user.orders.purchased.size == param.to_i
      else
        0 == param.to_i
      end
    end

    def matches_20_percent_promotion?
      matches? && order_have_promotion_id?
    end

    def order_have_promotion_id?(id=1)
      @order.payments.map(&:promotion_id).include?(id)
    end
  end
end
