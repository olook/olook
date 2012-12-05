class CreateClearsaleOrderResponses < ActiveRecord::Migration
  def change
    create_table :clearsale_order_responses do |t|
      t.references :order
      t.string :status
      t.decimal :score

      t.timestamps
    end
    add_index :clearsale_order_responses, :order_id
  end
end
