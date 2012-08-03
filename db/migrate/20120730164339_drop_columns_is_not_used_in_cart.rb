class DropColumnsIsNotUsedInCart < ActiveRecord::Migration
  def up
    remove_column :cart_items, :price
    remove_column :cart_items, :retail_price
    remove_column :cart_items, :discount
    remove_column :cart_items, :discount_source
  end

  def down
    change_table :cart_items do |t|
      t.decimal "price",           :precision => 8, :scale => 2, :default => 0.0,   :null => false
      t.decimal "retail_price",    :precision => 8, :scale => 2, :default => 0.0,   :null => false
      t.decimal "discount",        :precision => 8, :scale => 2, :default => 0.0,   :null => false
      t.string  "discount_source",                                                  :null => false
    end
  end
end