class AddTextColorToCollectionThemes < ActiveRecord::Migration
  def change
    add_column :collection_themes, :text_color, :string

  end
end
