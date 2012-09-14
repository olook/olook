class AddUserIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :user_id, :integer
    add_index :payments, :user_id
  end
end
