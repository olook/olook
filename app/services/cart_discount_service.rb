class CartDiscountService
  def initialize(cart, options={})
    @cart = cart
    @promotion = options[:promotion]
  end

  def calculate
    return price_with_promotion if eligible_promotion?
    return price_with_coupon if eligible_coupon?
    return @cart.sub_total
  end

  def base_price
    @cart.total_price
  end

  def final_price
    @final_price ||= calculate
  end

  def calculate_coupon_discount 
    coupon_value = @cart.coupon.value if @cart.coupon && !@cart.coupon.is_percentage?
    coupon_value = 0.0 if @cart.coupon && !should_override_promotion_discount?
    coupon_value ||= 0.0

    if coupon_value >= @cart.sub_total
      coupon_value = @cart.sub_total
    end      
    coupon_value
  end

  private
  def price_with_coupon
    @cart.coupon.calculate_for_cart(@cart)
  end

  def eligible_coupon?
    @cart.coupon && @cart.coupon.eligible_for_cart?(@cart)
  end

  def eligible_promotion? 
    @promotion && @promotion.eligible_for_cart?(@cart)
  end

  def price_with_promotion
    @promotion.calculate_for_cart(@cart) if @promotion
  end

  def should_override_promotion_discount?
    @cart.total_coupon_discount > @cart.total_promotion_discount
  end  
end