class ProductObserver < ActiveRecord::Observer
  observe :variant

  def after_update(variant)
    variant.product.delete_cache if variant.inventory.to_i == 0
  end
end
