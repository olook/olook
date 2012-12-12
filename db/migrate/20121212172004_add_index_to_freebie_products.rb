class AddIndexToFreebieProducts < ActiveRecord::Migration
  def change
    add_index :freebie_products, :product_id
    add_index :freebie_products, :freebie_id
  end
end
