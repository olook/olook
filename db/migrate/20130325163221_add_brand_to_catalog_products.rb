class AddBrandToCatalogProducts < ActiveRecord::Migration
  def change
    add_column :catalog_products, :brand, :string

  end
end
