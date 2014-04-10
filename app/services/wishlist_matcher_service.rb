class WishlistMatcherService
  def matches?(wishlist, variant_id)
    ((product_id_array_for(wishlist) & matching_product_array).size == 3) && matching_product_array.include?(product_id_for(variant_id))
  end

  private

  def product_id_for variant_id
    Variant.find(variant_id).product_id.to_s
  end

  def matching_product_array
    Setting.bunny_products.split(",")
  end

  def product_id_array_for wishlist
    wishlist.wished_products.map{|wp| wp.variant.product_id.to_s}
  end
end