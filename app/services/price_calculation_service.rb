class PriceCalculationService
  def initialize(product, options={})
    @product = product
    @coupon = options[:coupon]
    @promotion = options[:promotion]
  end

  def calculate
    return price_with_promotion if eligible_promotion?
    return price_with_coupon if eligible_coupon?
    return @product.retail_price if eligible_markdown?
    return @product.price
  end

  def final_price
    @final_price ||= calculate
  end


  private
  def price_with_coupon
    return @product.price * (1 - (@coupon.value * 0.01)) if @coupon.is_percentage?
    return @product.price - @coupon.value
  end

  def eligible_coupon?
    @coupon && @coupon.eligible_for_product?(@product)
  end

  def eligible_markdown?
    @product.retail_price < @product.price
  end

  def eligible_promotion? 
    @promotion && @promotion.eligible_for_product?(@product)
  end

  def price_with_promotion
    return @promotion.simulate_for_product(@product) if @promotion
  end
end


