class AddCustomUrlToCatalogBases < ActiveRecord::Migration
  def change
    add_column :catalog_bases, :custom_url, :boolean
  end
end
