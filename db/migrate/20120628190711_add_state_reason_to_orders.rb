class AddStateReasonToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :state_reason, :string

  end
end
