class CartDiscountService
  def initialize(cart, options={})
    @cart = cart
    @coupon = options[:coupon]
    @promotion = options[:promotion]
  end

  def calculate
    bd = best_discount # cache to avoid double processing on eligible_for_cart?
    return @final_price = bd.calculate_for_cart(@cart) if bd
    return @final_price = @cart.sub_total
  end

  def base_price
    @cart.total_price
  end

  def final_price
    @final_price ||= calculate
  end

  def best_discount
    return @promotion if eligible_promotion?
    return @coupon if eligible_coupon?
    return nil
  end

  def discount
    base_price - final_price
  end

  private
  def eligible_coupon?
    @coupon && @coupon.eligible_for_cart?(@cart)
  end

  def eligible_promotion?
    @promotion && @promotion.eligible_for_cart?(@cart)
  end
end
