class AddShippingServiceNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_service_name, :string, :limit => 5
    add_index  :orders, :shipping_service_name
  end
end
