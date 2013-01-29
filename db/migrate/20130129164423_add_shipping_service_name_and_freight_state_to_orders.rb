class AddShippingServiceNameAndFreightStateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_service_name, :string, :limit => 5
    add_index  :orders, :shipping_service_name
    add_column :orders, :freight_state, :string, :limit => 3
    add_index :orders, :freight_state
  end
end
