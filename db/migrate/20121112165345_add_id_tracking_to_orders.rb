class AddIdTrackingToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tracking_id, :integer

  end
end
