class CreateBraspagCallbacks < ActiveRecord::Migration
  def change
    create_table :braspag_callbacks do |t|
      t.string :order_id
      t.string :status
      t.integer :payment_method
      t.references :order
      t.references :payment

      t.timestamps
    end
  end
end
