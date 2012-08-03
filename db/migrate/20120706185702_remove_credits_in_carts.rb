class RemoveCreditsInCarts < ActiveRecord::Migration
  def self.up
    remove_column :carts, :credits
  end

  def self.down
    add_column :carts, :credits, :decimal, :precision => 8, :scale => 2, :default => 0.0,   :null => false
  end
end
