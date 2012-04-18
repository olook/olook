class GiftDiscountService
  def self.total_price_with_discount(products)
    products.map(&:retail_price).zip(percents).inject(0) { |sum, price| sum += price.first * price.second }
  end

  def self.price_for_product(product_id, position = 0)
    product = Product.find(product_id)
    (product.retail_price * percents[position]) if product
  end

  def self.percents
    [1.0 , 0.8, 0.6]
  end
end
