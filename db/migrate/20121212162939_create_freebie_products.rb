class CreateFreebieProducts < ActiveRecord::Migration
  def change
    create_table :freebie_products do |t|
      t.integer :product_id
      t.integer :freebie_id

      t.timestamps
    end
  end
end
