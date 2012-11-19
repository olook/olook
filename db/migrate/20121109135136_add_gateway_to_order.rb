class AddGatewayToOrder < ActiveRecord::Migration
  def up
    add_column :orders, :gateway, :integer
    Order.update_all(:gateway => 1)
  end

  def down
    remove_column :orders, :gateway
  end
end
