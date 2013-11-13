class CreateLiquidationPreviews < ActiveRecord::Migration
  def change
    create_table :liquidation_previews do |t|
      t.references :product
      t.string :name
      t.string :category
      t.string :subcategory
      t.decimal :price
      t.decimal :retail_price
      t.decimal :discount_percentage
      t.string :inventory
      t.string :color
      t.boolean :visible
      t.integer :visibility
      t.string :picture_url

      t.timestamps
    end
    add_index :liquidation_previews, :product_id
  end
end
