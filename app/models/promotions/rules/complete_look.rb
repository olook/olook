class CompleteLook < PromotionRule
  def name
    'Todos os produtos de um look estiverem no carrinho'
  end

  def need_param
    false
  end  

  def matches?(cart, parameter=nil)
    cart.items.each do |item|
      return true if all_related_products_in_cart?(item, cart)
    end
    false
  end

  private

  def all_related_products_in_cart?(item, cart)
    (item.product.related_products.map(&:id) << item.product.id).inject(true){|v,a| v  &&= cart.items.map{|i| i.product.id }.include?(a)} && item.product.related_products.size > 0
  end

end