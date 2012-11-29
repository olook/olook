class CreateGiftBoxesProducts < ActiveRecord::Migration
=begin
  def change
    create_table :gift_boxes_products do |t|
      t.integer :gift_box_id
      t.integer :product_id

      t.timestamps
    end
  end
=end
end
