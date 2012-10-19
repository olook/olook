class AddGatewayToPayment < ActiveRecord::Migration
  def up
    add_column :payments, :gateway, :integer
    Payment.update_all(:gateway => 1)
  end

  def down
    remove_column :payments, :gateway
  end
end
