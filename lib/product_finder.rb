# -*- encoding : utf-8 -*-
module ProductFinder

  def remove_color_variations(products)
    result = {}
    products.each do |product|
      result[product.name] ||= product
      if result[product.name].sold_out? && !product.sold_out?
        result[product.name] = product #replaces product sold_out, with current product if it's not sold_out
      end
    end
    result.values.sort! {|product, product2| product2.inventory <=> product.inventory}
  end

end
