class AddUserInformationsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :user_first_name, :string
    add_column :orders, :user_last_name, :string
    add_column :orders, :user_email, :string
    add_column :orders, :user_address, :string
    add_column :orders, :user_telephone, :string
    add_column :orders, :user_cpf, :string
    
    add_index :orders, :user_email
  end
end