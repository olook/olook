class CreateUserLiquidations < ActiveRecord::Migration
  def change
    create_table :user_liquidations do |t|
      t.references :user
      t.references :liquidation
      t.boolean :dont_want_to_see_again, :default => false

      t.timestamps
    end
    add_index :user_liquidations, :user_id
    add_index :user_liquidations, :liquidation_id
  end
end
