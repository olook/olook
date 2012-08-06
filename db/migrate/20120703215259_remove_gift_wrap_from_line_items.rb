class RemoveGiftWrapFromLineItems < ActiveRecord::Migration
  def change
    remove_column :line_items, :gift_wrap
  end
end
