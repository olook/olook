class ChangeOrderStateTransitions < ActiveRecord::Migration
  def up
  	add_column :order_state_transitions, :payment_response, :string
  	add_column :order_state_transitions, :payment_transaction_status, :string
  end

  def down
  	remove_column :order_state_transitions, :payment_response, :string
  	remove_column :order_state_transitions, :payment_transaction_status, :string
  end
end
