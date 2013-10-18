class DropCustomUrlColumnFromCatalogBases < ActiveRecord::Migration
  def up
    remove_column :catalog_bases, :custom_url
  end

  def down
    add_column :catalog_bases, :custom_url, :boolean
  end
end
