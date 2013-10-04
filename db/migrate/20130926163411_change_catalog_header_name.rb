class ChangeCatalogHeaderName < ActiveRecord::Migration
  def change
    rename_table :catalog_headers, :catalog_bases
  end
end
