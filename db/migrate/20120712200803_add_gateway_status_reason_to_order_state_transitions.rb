class AddGatewayStatusReasonToOrderStateTransitions < ActiveRecord::Migration
  def change
    add_column :order_state_transitions, :gateway_status_reason, :string

  end
end
