class CreateLiquidationCarousels < ActiveRecord::Migration
  def change
    create_table :liquidation_carousels do |t|
      t.integer :liquidation_id
      t.string :image
      t.integer :order

      t.timestamps
    end
  end
end
