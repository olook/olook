class RemoveVideoTitleFromCollectionThemes < ActiveRecord::Migration
  def up
    remove_column :collection_themes, :video_title
  end

  def down
    add_column :collection_themes, :video_title, :string
  end
end
