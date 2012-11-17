class CreditPaymentPolicy


  def initialize(cart)
    @cart = cart
  end

  def allow?
    full_price_items = @cart.items.select{ |item| item.variant.product.price == item.variant.product.retail_price}
    binding.pry
    ! full_price_items.empty?
  end
end
