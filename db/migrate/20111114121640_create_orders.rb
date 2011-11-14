class CreateOrders < ActiveRecord::Migration
<<<<<<< HEAD
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.timestamps
    end
=======
  def up
  end

  def down
>>>>>>> added migration: crate_orders
  end
end
