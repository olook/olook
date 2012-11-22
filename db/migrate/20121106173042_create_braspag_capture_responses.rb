class CreateBraspagCaptureResponses < ActiveRecord::Migration
  def change
    create_table :braspag_capture_responses do |t|
      t.integer :correlation_id
      t.boolean :success
      t.boolean :processed
      t.string :error_message
      t.string :braspag_transaction_id
      t.string :acquirer_transaction_id
      t.string :amount
      t.string :authorization_code
      t.string :return_code
      t.string :return_message
      t.integer :status

      t.timestamps
    end
  end
end
