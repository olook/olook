class CreditPaymentPolicy

  def initialize(cart)
    @cart = cart
  end

  def allow?
    full_price_items = @cart.items.select{ |item| item.price == item.retail_price}
    ! full_price_items.empty?
  end
end