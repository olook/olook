class AddCollectionThemeGroupReferencesOnCollectionTheme < ActiveRecord::Migration
  def change
    add_column :collection_themes, :collection_theme_group_id, :integer
    add_index  :collection_themes, :collection_theme_group_id
  end
end
