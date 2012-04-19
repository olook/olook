# -*- encoding : utf-8 -*-
class GiftDiscountService
  def self.total_price_for_products(products)
    products.map.with_index { |product,index| price_for_product(product,index) }.sum
  end

  def self.price_for_product(product, position = 0)
    (product.retail_price * percents[position.to_i]) if product
  end
  
  # Percent of the price to be considered according to the product position
  def self.percents
    [BigDecimal.new("1.0"), BigDecimal.new("0.8"), BigDecimal.new("0.6")]
  end
end
