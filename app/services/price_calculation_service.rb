class PriceCalculationService
  def initialize(product, options={})
    @product = product
    @coupon = options[:coupon]
  end

  def calculate
    return price_with_coupon if @coupon && @coupon.eligible_for_product?(@product)
    if @product.retail_price < @product.price
      @product.retail_price
    else
      @product.price
    end
  end

  def final_price
    @final_price ||= calculate
  end

  private
  def price_with_coupon
    @product.price * (1 - (@coupon.value * 0.01)) 
  end

  def eligible_coupon?
    
  end
end


