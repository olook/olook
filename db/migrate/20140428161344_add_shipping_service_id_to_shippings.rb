class AddShippingServiceIdToShippings < ActiveRecord::Migration
  def change
    add_column :shippings, :shipping_service_id, :integer
  end
end
