class AddPaymentResponseFieldsToPayment < ActiveRecord::Migration
  def change
    add_column :payments, "gateway_response_id", :string
    add_column :payments, "gateway_response_status", :string
    add_column :payments, "gateway_token", :text
    add_column :payments, "gateway_fee", :decimal, :precision => 8, :scale => 2
    add_column :payments, "gateway_origin_code", :string
    add_column :payments, "gateway_transaction_status", :string
    add_column :payments, "gateway_message", :string
    add_column :payments, "gateway_transaction_code", :string
    add_column :payments, "gateway_return_code", :integer
  end
end