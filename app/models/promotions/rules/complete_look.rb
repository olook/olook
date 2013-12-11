class CompleteLook < PromotionRule
  def name
    'Todos os produtos de um look estiverem no carrinho'
  end

  def need_param
    false
  end  

  def matches?(cart, parameter=nil)
    cart.items.each do |item|
      return true if all_related_products_in_cart?(item, cart) && has_related_products?(item)
    end
    false
  end

  private

  def all_related_products_in_cart?(item, cart)
    all_products_in_the_cart = cart.items.map{|item| item.product.id}
    product_ids_related_to_item = get_all_related_product_ids_for(item)
    contains_all_elements?(all_products_in_the_cart, product_ids_related_to_item)
  end

  def get_all_related_product_ids_for item
    (item.product.related_products.map(&:id) << item.product.id)
  end

  def has_related_products? item
    item.product.related_products.size > 0
  end

  def contains_all_elements? all_products_in_the_cart, product_ids_related_to_item
    product_ids_related_to_item & all_products_in_the_cart == product_ids_related_to_item
  end


end