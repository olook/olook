# -*- encoding : utf-8 -*-
class SpecificItem < PromotionRule

  def matches?(cart_items, products_list)
    (products_for(cart_items) & products_list).any?
  end

  private

    def products_for(cart_items)
      products = []
      cart_items.each do |item|
        products << item.product.id
      end
      products
    end
end

