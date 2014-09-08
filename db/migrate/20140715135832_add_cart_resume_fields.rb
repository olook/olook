class AddCartResumeFields < ActiveRecord::Migration
  def up
    change_table :carts do |t|
      t.integer :shipping_service_id
      t.string :payment_method
      t.text :payment_data
    end
  end

  def down
  end
end
