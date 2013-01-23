class ChangeScaleForValueOnCartItemAdjustment < ActiveRecord::Migration
  def change
    change_column :cart_item_adjustments, :value, :decimal, precision: 10, scale: 2
  end
end
