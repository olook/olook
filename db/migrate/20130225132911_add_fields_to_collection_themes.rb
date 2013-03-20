class AddFieldsToCollectionThemes < ActiveRecord::Migration
  def change
    add_column :collection_themes, :video_link, :string

    add_column :collection_themes, :header_image_alt, :string

  end
end
