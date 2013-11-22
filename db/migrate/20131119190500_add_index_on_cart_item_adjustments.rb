class AddIndexOnCartItemAdjustments < ActiveRecord::Migration
  def up
    add_index :cart_item_adjustments, :cart_item_id
  end
end
