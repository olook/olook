class AddIndexToStateInOrders < ActiveRecord::Migration
  def change
    add_index :orders, [:user_id, :state]
  end
end
