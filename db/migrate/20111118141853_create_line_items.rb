class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :variant_id
      t.integer :order_id
      t.integer :quantity
    end
  end
end
