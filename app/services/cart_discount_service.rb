class CartDiscountService
  def initialize(cart, options={})
    @cart = cart
    @coupon = options[:coupon]
    @promotion = options[:promotion]
  end

  def calculate
    @final_price = best_discount.calculate_for_cart(@cart)
  end

  def base_price
    @cart.sub_total
  end

  def final_price
    @final_price ||= calculate
  end

  def best_discount
    return @promotion if eligible_promotion?
    return @coupon if eligible_coupon?
    return NoDiscount.new
  end

  def discount
    base_price - final_price
  end

  class NoDiscount
    def calculate_for_cart(cart)
      cart.sub_total
    end

    def apply(cart); end
  end

  private
  def eligible_coupon?
    @coupon && @coupon.eligible_for_cart?(@cart)
  end

  def eligible_promotion?
    @promotion && @promotion.eligible_for_cart?(@cart)
  end
end
