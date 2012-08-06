class CreateCart < ActiveRecord::Migration
  def change
    
    create_table "carts" do |t|
      t.integer  "user_id"
      t.boolean  "notified",        :default => false, :null => false
      t.boolean  "gift_wrap",       :default => false, :null => false
      t.decimal  "credits",         :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal  "amount",          :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal  "amount_discount", :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal  "amount_increase", :precision => 8, :scale => 2, :default => 0.0, :null => false
    end

    add_index "carts", ["user_id"]
    add_index "carts", ["notified"]
    
    create_table "cart_items" do |t|
      t.integer "variant_id",      :null => false
      t.integer "cart_id",         :null => false
      t.integer "quantity",        :default => 1, :null => false
      t.integer "gift_position",   :default => 0, :null => false
      t.boolean "gift",            :default => false, :null => false
      t.decimal "price",           :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal "retail_price",    :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal "discount",        :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.string  "discount_source", :null => false
    end

    add_index "cart_items", ["cart_id"]
    add_index "cart_items", ["variant_id"]
    
  end
end
