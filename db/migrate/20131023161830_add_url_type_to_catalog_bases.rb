class AddUrlTypeToCatalogBases < ActiveRecord::Migration
  def change
    add_column :catalog_bases, :url_type, :integer
  end
end
