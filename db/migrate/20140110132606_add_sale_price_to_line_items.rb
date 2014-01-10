class AddSalePriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :sale_price, :decimal, precision: 10, scale: 2, default: 0
  end
end
