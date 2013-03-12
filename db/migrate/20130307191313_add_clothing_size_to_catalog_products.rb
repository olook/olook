class AddClothingSizeToCatalogProducts < ActiveRecord::Migration
  def change
    add_column :catalog_products, :cloth_size, :string
  end
end
