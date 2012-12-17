module Promotions
  class FreeItemStrategy
    attr_reader :user, :promotion

    def initialize promotion, user
      @promotion = promotion
      @user = user
    end

    def matches?(cart)
      cart.items.count >= promotion.param.to_i if cart
    end

    def calculate_value(item_price)
      0
    end
  end
end