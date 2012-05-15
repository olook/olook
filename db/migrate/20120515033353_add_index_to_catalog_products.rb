class AddIndexToCatalogProducts < ActiveRecord::Migration
  def change
    add_index :catalog_products, [:catalog_id, :category_id]
    add_index :user_infos, :user_id
  end
end