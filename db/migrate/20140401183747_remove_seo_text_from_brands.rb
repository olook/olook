class RemoveSeoTextFromBrands < ActiveRecord::Migration
  def up
    remove_column :brands, :seo_text
  end

  def down
    add_column :brands, :seo_text, :string
  end
end
