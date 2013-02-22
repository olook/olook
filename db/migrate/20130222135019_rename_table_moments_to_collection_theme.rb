class RenameTableMomentsToCollectionTheme < ActiveRecord::Migration
  def up
    rename_table :moments, :collection_themes
  end

  def down
    rename_table :collection_themes, :moments
  end
end
