class OrderEvent < ActiveRecord::Migration
  def change
    create_table :order_events do |t|
      t.integer :order_id
      t.text :message
      t.timestamps
    end
  end
end
