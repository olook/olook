class ProductDiscountService
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
    @coupon.calculate_for_product(@product)
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
    @promotion.calculate_for_product(@product) if @promotion
  end
end


