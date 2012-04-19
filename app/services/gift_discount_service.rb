
class GiftDiscountService
  def self.total_price_for_products(product_ids)
    product_ids.collect.with_index { |product_id,index| price_for_product(product_id,index) }.sum
  end

  def self.price_for_product(product_id, position = 0)
    product = Product.find(product_id)
    (product.retail_price * percents[position]) if product
  end
  
  # Percent of the price to be considered according to the product position
  def self.percents
    [BigDecimal.new("1.0"), BigDecimal.new("0.8"), BigDecimal.new("0.6")]
  end
end
