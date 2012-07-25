class AddSubtotalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :subtotal, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
  end
end
