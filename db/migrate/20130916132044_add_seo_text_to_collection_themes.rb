class AddSeoTextToCollectionThemes < ActiveRecord::Migration
  def change
    add_column :collection_themes, :seo_text, :string
  end
end
