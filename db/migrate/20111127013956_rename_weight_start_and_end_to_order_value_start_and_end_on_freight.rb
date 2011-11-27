class RenameWeightStartAndEndToOrderValueStartAndEndOnFreight < ActiveRecord::Migration
  def change
    remove_index "freight_prices", :name => "index_freight_prices_on_weight_end"
    remove_index "freight_prices", :name => "index_freight_prices_on_weight_start"
    
    rename_column :freight_prices, :weight_start, :order_value_start
    rename_column :freight_prices, :weight_end, :order_value_end

    add_index "freight_prices", ["order_value_end"], :name => "index_freight_prices_on_order_value_end"
    add_index "freight_prices", ["order_value_start"], :name => "index_freight_prices_on_order_value_start"
  end
end
