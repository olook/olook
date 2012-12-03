class CreateGiftBoxes < ActiveRecord::Migration
  def change
    create_table :gift_boxes do |t|
      t.string :name
      t.boolean :active
      t.string :thumb_image

      t.timestamps
    end
  end
end
