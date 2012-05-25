class AddShippingServiceToFreight < ActiveRecord::Migration
  def change
    add_column :freights, :shipping_service_id, :integer, :default => 1
    add_index :freights, :shipping_service_id
  end
end