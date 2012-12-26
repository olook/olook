class AddGiftWrapToCart < ActiveRecord::Migration
  def change
    add_column :carts, :gift_wrap, :boolean, default: false

  end
end
