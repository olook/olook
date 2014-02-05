class ProductObserver < ActiveRecord::Observer
  observe :product

  def before_update product
    variant = product.master_variant
    if variant.price_changed? || variant.retail_price_changed?
      product.price_logs.create(price: variant.price_was, retail_price: variant.retail_price_was)
    end
    if product.price_changed? || product.retail_price_changed?
      product.price_logs.create(price: product.price_was, retail_price: product.retail_price_was)
    end
  end

end

