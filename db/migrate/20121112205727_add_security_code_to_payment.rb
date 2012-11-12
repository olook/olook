class AddSecurityCodeToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :security_code, :string

  end
end
