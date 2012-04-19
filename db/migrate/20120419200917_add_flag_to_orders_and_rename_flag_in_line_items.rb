class AddFlagToOrdersAndRenameFlagInLineItems < ActiveRecord::Migration
  def change
    rename_column :orders, :gift_wrapped, :gift_wrap
    add_column :orders, :restricted, :boolean
    rename_column :line_items, :is_gift, :gift_wrap
  end
end
