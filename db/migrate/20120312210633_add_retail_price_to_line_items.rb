class AddRetailPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :retail_price, :decimal, :precision => 8, :scale => 3
  end
end
