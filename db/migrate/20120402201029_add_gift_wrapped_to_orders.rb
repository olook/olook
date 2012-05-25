class AddGiftWrappedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :gift_wrapped, :boolean, :default => false
  end
end
