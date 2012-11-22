class CreateBraspagAuthorizeResponses < ActiveRecord::Migration
  def change
    create_table :braspag_authorize_responses do |t|
      t.integer :correlation_id
      t.boolean :success
      t.string :error_message
      t.string :order_id
      t.string :braspag_order_id
      t.string :braspag_transaction_id
      t.string :amount
      t.integer :payment_method
      t.string :acquirer_transaction_id
      t.string :authorization_code
      t.string :return_code
      t.string :return_message
      t.integer :transaction_status
      t.string :credit_card_token
      t.boolean :processed

      t.timestamps
    end
  end
end
