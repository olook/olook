class AddColorAndInfoToCollectionThemes < ActiveRecord::Migration
  def change
    add_column :collection_themes, :bg_color, :string
    add_column :collection_themes, :font_color, :string
    add_column :collection_themes, :info, :text
  end
end
