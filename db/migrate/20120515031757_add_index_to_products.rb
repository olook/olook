class AddIndexToProducts < ActiveRecord::Migration
  def change
    add_index :products, :is_visible
    add_index :products, :category
    add_index :products, [:is_visible, :collection_id, :category]
    add_index :products_profiles, [:product_id, :profile_id]
  end
end