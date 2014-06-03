class CompleteLook < PromotionRule
  def name
    'Todos os produtos de um look estiverem no carrinho'
  end

  def need_param
    false
  end  

  def matches?(cart, parameter=nil)

    if cart.nil?
      return false
    end
    cart_item_ids = cart.items.map{|item| item.product.id}

    cart.items.each do |item|
      return true if item.product.list_contains_all_complete_look_products?(cart_item_ids)
    end
    false
  end

end