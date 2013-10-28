class CartDiscountService
  def initialize(cart, options={})
    @cart = cart
    @coupon = options[:coupon]
    @promotion = options[:promotion]
  end

  def calculate
    return price_with_promotion if eligible_promotion?
    return price_with_coupon if eligible_coupon?
    return @cart.total_price
  end

  def final_price
    @final_price ||= calculate
  end


  private
  def price_with_coupon
    @coupon.calculate_for_cart(@cart)
  end

  def eligible_coupon?
    @coupon && @coupon.eligible_for_cart?(@cart)
  end

  def eligible_promotion? 
    @promotion && @promotion.eligible_for_cart?(@cart)
  end

  def price_with_promotion
    @promotion.calculate_for_cart(@cart) if @promotion
  end
end