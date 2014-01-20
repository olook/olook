class AddLineItemIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :line_item_id, :integer
  end
end
