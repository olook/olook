class CreateBraspagResponses < ActiveRecord::Migration
  def change
    create_table :braspag_responses do |t|
      t.string :type
      t.integer :correlation_id
      t.boolean :success
      t.string :error_code
      t.string :error_message
      t.string :order_id
      t.integer :braspag_order_id
      t.integer :braspag_transaction_id
      t.integer :amount
      t.integer :payment_method
      t.string :acquirer_transaction_id
      t.string :authorization_code
      t.string :return_code
      t.string :return_message
      t.integer :transaction_status
      t.boolean :processed

      t.timestamps
    end
  end
end
