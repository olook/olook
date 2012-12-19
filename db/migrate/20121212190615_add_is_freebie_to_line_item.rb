class AddIsFreebieToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :is_freebie, :boolean, :default => false
    LineItem.update_all(is_freebie: false)
  end
end
