class AddFullLookPictureToLooks < ActiveRecord::Migration
  def change
    add_column :looks, :full_look_picture, :string
    rename_column :looks, :picture, :front_picture
  end
end
