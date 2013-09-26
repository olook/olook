class CreateProductPriceLogs < ActiveRecord::Migration
  def change
    create_table :product_price_logs do |t|
      t.integer :product_id
      t.decimal :price, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :retail_price, :precision => 8, :scale => 2, :default => 0.0, :null => false

      t.timestamps
    end
  end
end
