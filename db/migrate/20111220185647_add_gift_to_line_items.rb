class AddGiftToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :gift, :boolean
  end
end
