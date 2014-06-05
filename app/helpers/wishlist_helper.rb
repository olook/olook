# -*- encoding : utf-8 -*-
module WishlistHelper
  include ::CatalogsHelper

  def get_label_and_class_name(cart, wished_product)

    variant_number = wished_product.variant.number

    hash = if cart && cart.items.map{|item| item.variant.number}.include?(variant_number)
      { class_name: 'added_product', label: 'Adicionado'}
    else
      { class_name: 'add_product', label: 'Adicionar'}
    end

    if sold_out?(wished_product)
      hash.merge!({label: 'Esgotado', sold_out: 'soldOut'})
    end

    hash
  end

  private 
    def sold_out?(wished_product)
      wished_product.variant.inventory == 0
    end


end