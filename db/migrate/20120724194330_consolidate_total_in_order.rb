class ConsolidateTotalInOrder < ActiveRecord::Migration
  def change
    add_column :orders, :amount, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
    add_column :orders, :amount_discount, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
    add_column :orders, :amount_increase, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
    add_column :orders, :amount_paid, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
  end
end
