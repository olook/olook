class AddInCartNotifiedAtOrders < ActiveRecord::Migration
	def change
    add_column :orders, :in_cart_notified, :integer, :default => 0
  end
end
