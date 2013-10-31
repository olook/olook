class ProductDiscountService
  def initialize(product, options={})
    @product = product
    @markdown = Markdown.new
    @coupon = options[:coupon]
    @promotion = options[:promotion]
  end

  def calculate
    best_discount.calculate_for_product(@product) 
  end

  def base_price
    @product.price
  end

  def final_price
    @final_price ||= calculate
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
    return @markdown if eligible_markdown?
    return NoDiscount.new
  end

  class NoDiscount
    def calculate_for_product(product)
      product.price
    end

    def apply(cart); end
  end

  class Markdown
    def eligible_for_product?(product)
      product.retail_price < product.price
    end

    def calculate_for_product(product)
      product.retail_price
    end

    def apply(cart); end
  end

  private
  def eligible_coupon?
    @coupon && @coupon.eligible_for_product?(@product)
  end

  def eligible_markdown?
    @markdown.eligible_for_product?(@product)
  end

  def eligible_promotion?
    @promotion && @promotion.eligible_for_product?(@product)
  end
end


