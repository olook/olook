class ChangeColumnProductListOnCatalogBases < ActiveRecord::Migration
  def up
    change_column :catalog_bases, :product_list, :text
  end

  def down
    change_column :catalog_bases, :product_list, :string
  end
end
