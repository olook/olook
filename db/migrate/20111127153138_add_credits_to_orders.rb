class AddCreditsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :credits, :decimal, :precision => 8, :scale => 2
  end
end
