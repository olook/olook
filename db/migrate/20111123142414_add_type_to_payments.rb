class AddTypeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :type, :string
  end
end
