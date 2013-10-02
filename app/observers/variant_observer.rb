class VariantObserver < ActiveRecord::Observer
  observe :variant

  def after_update(variant)
    inventory_changes = variant.changes['inventory']
    if inventory_changes && (
      (inventory_changes.first.to_i.zero? && inventory_changes.last.to_i > 0) ||
      (inventory_changes.last.to_i.zero? && inventory_changes.first.to_i > 0)
    )
      variant.product.delete_cache
    end
  end
end
