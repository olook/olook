class ProductObserver < ActiveRecord::Observer
  observe :product

  def before_update product
    if product.master_variant.price_changed? || product.master_variant.retail_price_changed?
      product.price_logs.create(price: product.price, retail_price: product.retail_price)
    end
  end

end

