class AddProductIdToLiquidationCarousels < ActiveRecord::Migration
  def change
    add_column :liquidation_carousels, :product_id, :integer
  end
end
