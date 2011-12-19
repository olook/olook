class AddIdentificationCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :identification_code, :string
    add_index :orders, :identification_code, :unique => true
  end
end
