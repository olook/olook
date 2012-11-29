class AddIsKitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_kit, :boolean, :default => false
  end
end
