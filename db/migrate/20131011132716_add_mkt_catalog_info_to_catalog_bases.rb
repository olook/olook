class AddMktCatalogInfoToCatalogBases < ActiveRecord::Migration
  def change
    add_column :catalog_bases, :custom_url, :string
    add_column :catalog_bases, :product_list, :string
    add_column :catalog_bases, :organic_url, :string
  end
end
