class DropLookBookTables < ActiveRecord::Migration
  def change
    drop_table :lookbooks
    drop_table :images
    drop_table :lookbook_image_maps
    drop_table :lookbooks_products
  end
end
