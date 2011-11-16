class PaymentResponse < ActiveRecord::Migration
  def change
    create_table :payment_responses do |t|
      t.integer :payment_id
      t.string :response_id
      t.string :response_status
      t.text :token
      t.decimal :total_paid, :precision => 8, :scale => 2
      t.decimal :gateway_fee, :precision => 8, :scale => 2
      t.string :gateway_code
      t.string :transaction_status
      t.string :message
      t.string :transaction_code
      t.integer :return_code
      t.timestamps
    end
  end
end
