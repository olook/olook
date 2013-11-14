class AddCollectionToLiquidationPreviews < ActiveRecord::Migration
  def change
    add_column :liquidation_previews, :collection, :string
  end
end
