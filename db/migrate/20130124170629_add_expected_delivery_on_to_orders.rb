class AddExpectedDeliveryOnToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :expected_delivery_on, :datetime

    add_index :orders, :expected_delivery_on
  end
end
