class AddSalePriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :sale_price, :decimal
  end
end
