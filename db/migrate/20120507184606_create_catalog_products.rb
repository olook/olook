class CreateCatalogProducts < ActiveRecord::Migration
  def change
    create_table :catalog_products do |t|
      t.references :catalog
      t.references :product
      t.integer :category_id
      t.string  :subcategory_name
      t.string  :subcategory_name_label
      t.integer :shoe_size
      t.string  :shoe_size_label
      t.string  :heel
      t.string  :heel_label
      t.decimal :original_price, :precision => 10, :scale => 2
      t.decimal :retail_price, :precision => 10, :scale => 2
      t.float   :discount_percent
      t.integer :variant_id
      t.integer :inventory
      
      t.timestamps
    end
    
    add_index :catalog_products, :catalog_id
    add_index :catalog_products, :product_id
    add_index :catalog_products, :category_id
    add_index :catalog_products, [:category_id, :inventory]
    add_index :catalog_products, :subcategory_name
    add_index :catalog_products, :original_price
    add_index :catalog_products, :retail_price
    add_index :catalog_products, :shoe_size
    add_index :catalog_products, :heel
  end
end
