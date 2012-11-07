class AddInitialInventoryToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :initial_inventory, :integer, :default => 0

  end
end
