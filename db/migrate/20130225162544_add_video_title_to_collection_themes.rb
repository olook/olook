class AddVideoTitleToCollectionThemes < ActiveRecord::Migration
  def change
    add_column :collection_themes, :video_title, :string
  end
end
