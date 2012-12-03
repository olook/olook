class CreditPaymentPolicy

  def initialize(cart)
    @cart = cart
  end

  def allow?
    fullprice_items_without_suggested_product.any?
  end

  private
    def fullprice_items_without_suggested_product
      exclude_suggested_products_from fullprice_items
    end

    def fullprice_items
      @cart.items.select{ |item| item.price == item.retail_price}
    end

    def exclude_suggested_products_from cart_items
      cart_items.reject { |cart_item| cart_item.product.id == Setting.checkout_suggested_product_id.to_i}
    end

end