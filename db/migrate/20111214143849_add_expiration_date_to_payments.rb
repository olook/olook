class AddExpirationDateToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payment_expiration_date, :datetime
    add_index :payments, :payment_expiration_date
  end
end
