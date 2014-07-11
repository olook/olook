module CartProfit
  class CartCalculator
    attr_reader :cart

    def initialize cart
      @cart = cart
    end

    def items_subtotal
      return 0 if cart.nil? || (cart && cart.items.nil?)
      cart.items.inject(0){|sum,item| sum += item.price * item.quantity}
    end

    def items_discount
      return 0 if cart.nil? || (cart && cart.items.nil?)
      final_price = cart.items.inject(0){|sum,item| sum += item.retail_price * item.quantity}
      final_price - items_subtotal
    end

    def user_credits_value
      (cart.use_credits && cart.allow_credit_payment?) ? cart.user.user_credits_for(:loyalty_program).total : BigDecimal.new(0)
    end

    def cart_addings
      gift_price
    end

    def items_total
      return 0 if cart.nil? || (cart && cart.items.nil?)
      subtotal = items_subtotal + items_discount
      subtotal += gift_price - user_credits_value
    end

    private
    def gift_price
      cart.increment_from_gift_wrap || BigDecimal.new(0)
    end
  end
end
