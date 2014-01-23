# -*- encoding : utf-8 -*-
module WishlistHelper
  include ::CatalogsHelper

  def get_label_and_class_name(cart, wished_product)

    variant_number = wished_product.variant.number
    sold_out_class = sold_out?(wished_product) ? 'soldOut' : ''
    binding.pry
    if cart.items.map{|item| item.variant.number}.include?(variant_number)
      label = sold_out?(wished_product) ? 'Esgotado' : 'Adicionado'
      { class_name: 'added_product', label: label, sold_out: sold_out_class }
    else
      label = sold_out?(wished_product) ? 'Esgotado' : 'Adicionar'
      { class_name: 'add_product', label: label, sold_out: sold_out_class }
    end
  end

  private 
    def sold_out?(wished_product)
      wished_product.variant.inventory = 0
    end


end