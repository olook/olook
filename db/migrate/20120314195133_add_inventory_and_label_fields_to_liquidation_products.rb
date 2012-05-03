class AddInventoryAndLabelFieldsToLiquidationProducts < ActiveRecord::Migration
  def change
    add_column :liquidation_products, :inventory, :integer
    add_column :liquidation_products, :shoe_size_label, :string
    add_column :liquidation_products, :heel_label, :string
    add_column :liquidation_products, :subcategory_name_label, :string
  end
end
