# -*- encoding : utf-8 -*-
class SpecificItem < PromotionRule

  def eg
    "Somente após adicionar UM dos produtos listados que o desconto é ativado"
  end

  def label_text
    "Lista de produtos (separados por ,)"
  end

  def matches?(cart, products)
    (get_product_ids_from(cart.items) & product_ids_list_for(products)).size == 1
  end

  private

    def get_product_ids_from(cart_items)
      cart_items.map { |item| item.product.id }
    end

    def product_ids_list_for(products)
      products.split(/\D/).map { |id| id.strip.to_i }.select { |id| !id.nil? && id != '' }
    end

end

