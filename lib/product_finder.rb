# -*- encoding : utf-8 -*-
module ProductFinder

  def remove_color_variations(products)
    result = []
    already_displayed = []
    displayed_and_sold_out = {}

    products.each_with_index do |product, index|
      # Only add to the list the products that aren't already shown
      if already_displayed.include?(product.producer_code)
        # If a product of the same color was already displayed but was sold out
        # and the algorithm find another color that isn't, replace the sold out one
        # by the one that's not sold out
        if displayed_and_sold_out[product.producer_code] && !product.sold_out?
          result[displayed_and_sold_out[product.producer_code]] = product
          displayed_and_sold_out.delete product.producer_code
        end
      else
        result << product
        already_displayed << product.producer_code
        displayed_and_sold_out[product.producer_code] = index if product.sold_out?
      end
    end
    result.sort! {|product, product2| product2.inventory <=> product.inventory}
  end

end
