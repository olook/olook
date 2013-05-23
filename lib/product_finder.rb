# -*- encoding : utf-8 -*-
module ProductFinder

  def remove_color_variations(products)
    result = {}
    products.each do |product|
      result[product.producer_code] ||= product
      if result[product.producer_code].sold_out? && !product.sold_out?
        result[product.producer_code] = product #replaces product sold_out, with current product if it's not sold_out
      end
    end
    result.values.sort! {|product, product2| product2.inventory <=> product.inventory}
  end

end
