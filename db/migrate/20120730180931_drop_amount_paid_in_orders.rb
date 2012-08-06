class DropAmountPaidInOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :amount
  end

  def down
    add_column :orders, :amount, :precision => 8, :scale => 2, :default => 0.0,   :null => false
  end
end
