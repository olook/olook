class WishlistMatcherService
  def matches? wishlist
    (product_id_array_for(wishlist) & matching_product_array).size == 3
  end

  private

  def matching_product_array
    Setting.bunny_products.split(",")
  end

  def product_id_array_for wishlist
    wishlist.wished_products.map{|wp| wp.variant.product_id}
  end
end