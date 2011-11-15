class AddIndexesToZipAndWeightOnFreightPrices < ActiveRecord::Migration
  def change
    add_index :freight_prices, :shipping_company_id
    add_index :freight_prices, :zip_start
    add_index :freight_prices, :zip_end
    add_index :freight_prices, :weight_start
    add_index :freight_prices, :weight_end
  end
end
