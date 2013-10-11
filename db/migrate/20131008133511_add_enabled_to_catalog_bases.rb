class AddEnabledToCatalogBases < ActiveRecord::Migration
  def change
    add_column :catalog_bases, :enabled, :boolean
  end
end
