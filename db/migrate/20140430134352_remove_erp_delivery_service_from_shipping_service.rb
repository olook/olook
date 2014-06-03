class RemoveErpDeliveryServiceFromShippingService < ActiveRecord::Migration
  def up
    remove_column :shipping_services, :erp_delivery_service
  end

  def down
    add_column :shipping_services, :erp_delivery_service, :string
  end
end
