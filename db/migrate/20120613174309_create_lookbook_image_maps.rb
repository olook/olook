class CreateLookbookImageMaps < ActiveRecord::Migration
  def change
    create_table :lookbook_image_maps, force: true do |t|
      t.references :lookbook
      t.references :image
      t.references :product
      t.integer :coord_x
      t.integer :coord_y

      t.timestamps
    end
    add_index :lookbook_image_maps, :lookbook_id
    add_index :lookbook_image_maps, :image_id
    add_index :lookbook_image_maps, :product_id
  end
end
