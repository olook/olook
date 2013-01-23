class CreateCartItemAdjustments < ActiveRecord::Migration
  def change
    create_table :cart_item_adjustments do |t|
      t.decimal :value
      t.integer :cart_item_id
      t.string :source

      t.timestamps
    end
  end
end
