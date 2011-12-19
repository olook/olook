class AddNewFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :user_name, :string
    add_column :payments, :credit_card_number, :string
    add_column :payments, :bank, :string
    add_column :payments, :expiration_date, :string
    add_column :payments, :telephone, :string
    add_column :payments, :user_birthday, :string
    add_column :payments, :payments, :integer
  end
end
