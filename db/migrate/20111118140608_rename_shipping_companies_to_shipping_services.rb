class RenameShippingCompaniesToShippingServices < ActiveRecord::Migration
  def change
    rename_table :shipping_companies, :shipping_services

    remove_index "freight_prices", :name => "index_freight_prices_on_shipping_company_id"
    rename_column :freight_prices, :shipping_company_id, :shipping_service_id
    add_index "freight_prices", ["shipping_service_id"], :name => "index_freight_prices_on_shipping_service_id"
  end
end
