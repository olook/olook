class AddIsGiftToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :is_gift, :boolean, :default => false
  end
end
