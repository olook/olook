class CreateWishedProducts < ActiveRecord::Migration
  def change
    create_table :wished_products do |t|
      t.integer :variant_id
      t.integer :wishlist_id
      t.decimal :retail_price

      t.timestamps
    end
  end
end
