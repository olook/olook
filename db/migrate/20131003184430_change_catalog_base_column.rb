class ChangeCatalogBaseColumn < ActiveRecord::Migration
  def change
    rename_column :catalog_bases, :h1, :seo_text
    remove_column :catalog_bases, :h2
  end
end
