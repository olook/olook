class AddVariantIdToLiquidationProducts < ActiveRecord::Migration
  def change
    add_column :liquidation_products, :variant_id, :integer
  end
end
