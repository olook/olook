class AddStateMachineToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :state, :string
  end
end
