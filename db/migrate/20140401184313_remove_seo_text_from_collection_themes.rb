class RemoveSeoTextFromCollectionThemes < ActiveRecord::Migration
  def up
    remove_column :collection_themes, :seo_text
  end

  def down
    add_column :collection_themes, :seo_text, :string
  end
end
