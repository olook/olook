class ProductDiscountService
  def initialize(product, options={})
    @product = product
    @cart = options[:cart]
    @coupon = options[:coupon]
    @promotion = options[:promotion]
  end

  def calculate
    @final_price = best_discount.calculate_for_product(@product, cart: @cart)
  end

  def base_price
    @product.price
  end

  def final_price
    @final_price ||= calculate
  end

  def discount
    base_price.to_f - final_price.to_f
  end

  def has_any_discount?
    eligible_markdown? || eligible_coupon? || eligible_promotion?
  end

  # Método principal da classe
  # Define qual é o desconto que deve ser aplicado no produto
  # e em qual ordem.
  def best_discount
    return @promotion if eligible_promotion?
    return @coupon if eligible_coupon?
    return NoDiscount.new
  end

  class NoDiscount
    def calculate_for_product(product, opts)
      product.price
    end

    def apply(cart); end
  end

  private
  def eligible_coupon?
    @coupon && @coupon.eligible_for_product?(@product, cart: @cart)
  end

  def eligible_promotion?
    @promotion && @promotion.eligible_for_product?(@product, cart: @cart)
  end
end


