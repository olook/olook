# -*- encoding : utf-8 -*-
class SpecificItem < PromotionRule

  def matches?(cart, products)
    (products_for(cart.items) & products_list_for(products)).any?
  end

  private

    def products_for(cart_items)
      products = []
      cart_items.each do |item|
        products << item.product.id
      end
      products
    end

    def products_list_for(products)
      products.delete(",").split.map { |id| id.to_i }
    end

end

