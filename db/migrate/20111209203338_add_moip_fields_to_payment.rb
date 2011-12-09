class AddMoipFieldsToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :gateway_status, :integer
    add_column :payments, :gateway_code, :string
    add_column :payments, :gateway_type, :string
  end
end
