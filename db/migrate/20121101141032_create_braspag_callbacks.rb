class CreateBraspagCallbacks < ActiveRecord::Migration
  def change
    create_table :braspag_callbacks do |t|
      t.string :transaction_identification
      t.string :status
      t.integer :payment_method
      t.references :order
      t.references :payment


      t.timestamps
    end
    add_index  :braspag_callbacks, :order_id
    add_index  :braspag_callbacks, :payment_id
    add_index  :braspag_callbacks, :transaction_identification
  end
end
