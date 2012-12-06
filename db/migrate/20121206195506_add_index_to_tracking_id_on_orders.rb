class AddIndexToTrackingIdOnOrders < ActiveRecord::Migration
  def change
    add_index :orders, :tracking_id
  end
end
