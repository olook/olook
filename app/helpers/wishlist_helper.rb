# -*- encoding : utf-8 -*-
module WishlistHelper

  def get_label_and_class_name(cart, wished_product)

    variant_number = wished_product.variant.number
    
    if cart.items.map{|item| item.variant.number}.include?(variant_number)
      { class_name: 'added_product', label: 'Adicionado' }
    else
      { class_name: 'add_product', label: 'Adicionar' }
    end
  end
end