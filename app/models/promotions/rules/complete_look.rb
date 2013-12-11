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
    complete_look_products(item).inject(true){|result,product| result &&= product_is_in_the_cart?(product,cart.items)}
  end

  def complete_look_products item
    (item.product.related_products.map(&:id) << item.product.id)
  end

  def has_related_products? item
    item.product.related_products.size > 0
  end

  def product_is_in_the_cart?(product, cart_items)
    cart_items.map{|i| i.product.id }.include?(product)
  end

end