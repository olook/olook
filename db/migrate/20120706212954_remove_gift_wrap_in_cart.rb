class RemoveGiftWrapInCart < ActiveRecord::Migration
  def up
    remove_column :carts, :gift_wrap
  end

  def down
    add_column :carts, :gift_wrap, :boolean
  end
end