class CompleteLook < PromotionRule
  def name
    'Todos os produtos de um look estiverem no carrinho'
  end

  def need_param
    false
  end  

  def matches?(cart, parameter=nil)
    cart_item_ids = cart.items.map{|item| item.product.id}

    cart.items.each do |item|
      return true if item.product.list_contains_all_related_products?(cart_item_ids)
    end
    false
  end

end