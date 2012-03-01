class CreateLiquidationProducts < ActiveRecord::Migration
  def change
    create_table :liquidation_products do |t|
      t.references :liquidation
      t.references :product
      t.integer :category_id
      t.string :subcategory_name
      t.decimal :original_price
      t.decimal :retail_price
      t.float :discount_percent
      t.integer :shoe_size
      t.float :heel

      t.timestamps
    end
    add_index :liquidation_products, :liquidation_id
    add_index :liquidation_products, :product_id
  end
end
