class CreateLiquidationPreviews < ActiveRecord::Migration
  def change
    create_table :liquidation_previews do |t|
      t.references :product
      t.integer :visibility

      t.timestamps
    end
    add_index :liquidation_previews, :product_id
  end
end
