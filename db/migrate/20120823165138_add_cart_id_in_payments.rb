class AddCartIdInPayments < ActiveRecord::Migration
  def up
    add_column :payments, :cart_id, :integer
    add_index "payments", ["cart_id"]

    add_column :moip_callbacks, :payment_id, :integer
    add_index "moip_callbacks", ["payment_id"]
  end

  def down
    remove_column :payments, :cart_id
    remove_column :moip_callbacks, :payment_id
  end
end