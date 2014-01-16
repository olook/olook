module CartProfit
  class CartCalculator
    attr_reader :cart

    def initialize cart
      @cart = cart
    end

    def items_subtotal(avoid_adjustment=true)
      return 0 if cart.nil? || (cart && cart.items.nil?)
      cart.items.inject(0){|sum,item| sum += item.retail_price(avoid_ajustment: avoid_adjustment) * item.quantity}
    end

    def items_total
      return 0 if cart.nil? || (cart && cart.items.nil?)
      subtotal = items_subtotal(false)
      subtotal += gift_price - user_credits_value
    end

    private
    def gift_price
      cart.increment_from_gift_wrap || BigDecimal.new(0)
    end
    def user_credits_value
      (cart.use_credits && cart.allow_credit_payment?) ? cart.user.user_credits_for(:loyalty_program).total : BigDecimal.new(0)
    end
  end
end
