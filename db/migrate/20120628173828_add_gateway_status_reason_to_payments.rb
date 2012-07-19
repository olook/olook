class AddGatewayStatusReasonToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :gateway_status_reason, :string

  end
end
