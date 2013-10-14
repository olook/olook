class RemoveCustomUrlFromCatalogBases < ActiveRecord::Migration
  def change
    remove_column :catalog_bases, :custom_url
  end
end
