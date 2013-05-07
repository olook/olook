class AddDescriptionToGiftBoxes < ActiveRecord::Migration
  def change
    add_column :gift_boxes, :description, :text
  end
end
