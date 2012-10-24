class AddIsVisibleToLiquidations < ActiveRecord::Migration
  def change
    add_column :liquidations, :visible, :boolean, :default => true

  end
end
