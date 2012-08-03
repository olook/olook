class RemoveColumnsNotUsedInCart < ActiveRecord::Migration
  def up
    remove_column :carts, :amount
    remove_column :carts, :amount_discount
    remove_column :carts, :amount_increase
  end

  def down
    add_column :carts, :amount, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
    add_column :carts, :amount_discount, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
    add_column :carts, :amount_increase, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
  end
end