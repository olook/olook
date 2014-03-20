class RenameCatalogBaseToHeader < ActiveRecord::Migration
  def change
    rename_table :catalog_bases, :headers
  end
end
