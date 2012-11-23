class CreateGiftBoxesProducts < ActiveRecord::Migration
  def change
    create_table :gift_boxes_products do |t|
      t.string :gift_box_id
      t.string :product_id

      t.timestamps
    end
  end
end
